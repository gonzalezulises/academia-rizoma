'use client'

interface VideoPlayerProps {
  url: string
  onEnded?: () => void
}

// Extract YouTube video ID from various URL formats
function getYouTubeVideoId(url: string): string | null {
  const patterns = [
    /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/|youtube-nocookie\.com\/embed\/)([^&?\s]+)/,
    /youtube\.com\/v\/([^&?\s]+)/,
  ]

  for (const pattern of patterns) {
    const match = url.match(pattern)
    if (match) return match[1]
  }
  return null
}

// Extract Vimeo video ID
function getVimeoVideoId(url: string): string | null {
  const match = url.match(/vimeo\.com\/(?:video\/)?(\d+)/)
  return match ? match[1] : null
}

// Determine video type and get embed URL
function getEmbedUrl(url: string): { type: 'youtube' | 'vimeo' | 'direct'; embedUrl: string; watchUrl?: string } | null {
  const youtubeId = getYouTubeVideoId(url)
  if (youtubeId) {
    return {
      type: 'youtube',
      embedUrl: `https://www.youtube-nocookie.com/embed/${youtubeId}?rel=0&modestbranding=1`,
      watchUrl: `https://www.youtube.com/watch?v=${youtubeId}`,
    }
  }

  const vimeoId = getVimeoVideoId(url)
  if (vimeoId) {
    return {
      type: 'vimeo',
      embedUrl: `https://player.vimeo.com/video/${vimeoId}`,
      watchUrl: `https://vimeo.com/${vimeoId}`,
    }
  }

  // Direct video file
  if (url.match(/\.(mp4|webm|ogg)(\?|$)/i)) {
    return { type: 'direct', embedUrl: url }
  }

  return null
}

export function VideoPlayer({ url }: VideoPlayerProps) {
  const embedInfo = getEmbedUrl(url)

  if (!embedInfo) {
    return (
      <div className="relative w-full aspect-video bg-black rounded-xl overflow-hidden flex items-center justify-center text-gray-400">
        <div className="text-center">
          <span className="text-6xl block mb-4">🎬</span>
          <p>Formato de video no soportado</p>
          <a href={url} target="_blank" rel="noopener noreferrer" className="text-sm mt-2 text-blue-400 hover:underline">
            Abrir enlace original
          </a>
        </div>
      </div>
    )
  }

  if (embedInfo.type === 'direct') {
    return (
      <div className="relative w-full aspect-video bg-black rounded-xl overflow-hidden">
        <video
          src={embedInfo.embedUrl}
          controls
          className="w-full h-full"
          playsInline
        >
          Tu navegador no soporta el elemento de video.
        </video>
      </div>
    )
  }

  return (
    <div>
      <div className="relative w-full aspect-video bg-black rounded-xl overflow-hidden">
        <iframe
          src={embedInfo.embedUrl}
          className="absolute inset-0 w-full h-full border-0"
          allowFullScreen
          loading="lazy"
          referrerPolicy="strict-origin-when-cross-origin"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          title="Video player"
        />
      </div>
      {embedInfo.watchUrl && (
        <div className="mt-2 text-right">
          <a
            href={embedInfo.watchUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm text-gray-500 dark:text-gray-400 hover:text-rizoma-green dark:hover:text-rizoma-green-light"
          >
            Ver en {embedInfo.type === 'youtube' ? 'YouTube' : 'Vimeo'} &rarr;
          </a>
        </div>
      )}
    </div>
  )
}
