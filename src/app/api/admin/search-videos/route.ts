import { NextResponse } from 'next/server'
import { requireAdmin, isAuthError } from '@/lib/auth/helpers'

interface VideoResult {
  id: string
  title: string
  channelTitle: string
  thumbnail: string
  duration: string
  viewCount: string
  url: string
}

function formatDuration(iso8601: string): string {
  const match = iso8601.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/)
  if (!match) return '0:00'
  const h = match[1] ? parseInt(match[1]) : 0
  const m = match[2] ? parseInt(match[2]) : 0
  const s = match[3] ? parseInt(match[3]) : 0
  if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
  return `${m}:${String(s).padStart(2, '0')}`
}

export async function POST(request: Request) {
  const auth = await requireAdmin()
  if (isAuthError(auth)) return auth

  const apiKey = process.env.YOUTUBE_API_KEY
  if (!apiKey) {
    return NextResponse.json({ videos: [], configured: false })
  }

  try {
    const { title, objectives, language = 'es', maxResults = 5 } = await request.json()

    const keywords = objectives?.slice(0, 2)?.join(' ') || ''
    const query = `${title} ${keywords} tutorial`.trim()

    // Search for videos
    const searchUrl = new URL('https://www.googleapis.com/youtube/v3/search')
    searchUrl.searchParams.set('part', 'snippet')
    searchUrl.searchParams.set('q', query)
    searchUrl.searchParams.set('type', 'video')
    searchUrl.searchParams.set('maxResults', String(Math.min(maxResults, 10)))
    searchUrl.searchParams.set('relevanceLanguage', language)
    searchUrl.searchParams.set('videoEmbeddable', 'true')
    searchUrl.searchParams.set('key', apiKey)

    const searchRes = await fetch(searchUrl.toString())
    if (!searchRes.ok) throw new Error(`YouTube search error: ${searchRes.status}`)
    const searchData = await searchRes.json()

    const videoIds = searchData.items?.map((item: { id: { videoId: string } }) => item.id.videoId) || []
    if (videoIds.length === 0) {
      return NextResponse.json({ videos: [], configured: true })
    }

    // Get video details (duration, stats)
    const detailsUrl = new URL('https://www.googleapis.com/youtube/v3/videos')
    detailsUrl.searchParams.set('part', 'contentDetails,statistics')
    detailsUrl.searchParams.set('id', videoIds.join(','))
    detailsUrl.searchParams.set('key', apiKey)

    const detailsRes = await fetch(detailsUrl.toString())
    if (!detailsRes.ok) throw new Error(`YouTube details error: ${detailsRes.status}`)
    const detailsData = await detailsRes.json()

    const detailsMap = new Map<string, { duration: string; viewCount: string }>()
    for (const item of detailsData.items || []) {
      detailsMap.set(item.id, {
        duration: formatDuration(item.contentDetails.duration),
        viewCount: item.statistics.viewCount || '0',
      })
    }

    const videos: VideoResult[] = searchData.items.map((item: {
      id: { videoId: string }
      snippet: { title: string; channelTitle: string; thumbnails: { medium: { url: string } } }
    }) => {
      const details = detailsMap.get(item.id.videoId)
      return {
        id: item.id.videoId,
        title: item.snippet.title,
        channelTitle: item.snippet.channelTitle,
        thumbnail: item.snippet.thumbnails.medium.url,
        duration: details?.duration || '0:00',
        viewCount: details?.viewCount || '0',
        url: `https://www.youtube.com/embed/${item.id.videoId}`,
      }
    })

    return NextResponse.json({ videos, configured: true })
  } catch (error) {
    console.error('Video search error:', error)
    return NextResponse.json(
      { error: error instanceof Error ? error.message : 'Video search failed' },
      { status: 500 }
    )
  }
}
