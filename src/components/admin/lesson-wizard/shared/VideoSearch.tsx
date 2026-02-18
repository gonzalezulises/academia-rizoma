'use client'

import { useState } from 'react'

interface VideoResult {
  id: string
  title: string
  channelTitle: string
  thumbnail: string
  duration: string
  viewCount: string
  url: string
}

interface VideoSearchProps {
  onSelect: (url: string) => void
  title: string
  objectives: string[]
  currentUrl: string | null
}

export default function VideoSearch({ onSelect, title, objectives, currentUrl }: VideoSearchProps) {
  const [videos, setVideos] = useState<VideoResult[]>([])
  const [searching, setSearching] = useState(false)
  const [searched, setSearched] = useState(false)
  const [configured, setConfigured] = useState<boolean | null>(null)
  const [manualUrl, setManualUrl] = useState(currentUrl || '')
  const [error, setError] = useState<string | null>(null)

  const searchVideos = async () => {
    setSearching(true)
    setError(null)

    try {
      const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''
      const res = await fetch(`${basePath}/api/admin/search-videos`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, objectives, maxResults: 5 }),
      })

      const data = await res.json()
      setConfigured(data.configured ?? false)
      setVideos(data.videos || [])
      setSearched(true)
    } catch {
      setError('Error al buscar videos')
    } finally {
      setSearching(false)
    }
  }

  return (
    <div className="space-y-3">
      {/* Manual URL input */}
      <div>
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          URL del video (YouTube embed)
        </label>
        <div className="flex gap-2">
          <input
            type="url"
            value={manualUrl}
            onChange={(e) => {
              setManualUrl(e.target.value)
              onSelect(e.target.value)
            }}
            className="flex-1 px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
            placeholder="https://www.youtube.com/embed/..."
          />
          <button
            type="button"
            onClick={searchVideos}
            disabled={searching || !title}
            className="px-4 py-2 text-sm bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:opacity-50 flex items-center gap-2"
          >
            {searching ? (
              <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
            ) : (
              <svg className="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M19.615 3.184c-3.604-.246-11.631-.245-15.23 0C.488 3.45.029 5.804 0 12c.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0C23.512 20.55 23.971 18.196 24 12c-.029-6.185-.484-8.549-4.385-8.816zM9 16V8l8 4-8 4z"/>
              </svg>
            )}
            Buscar
          </button>
        </div>
      </div>

      {error && <p className="text-sm text-red-600 dark:text-red-400">{error}</p>}

      {searched && configured === false && (
        <p className="text-sm text-gray-500 dark:text-gray-400">
          YouTube API no configurada. Ingresa la URL manualmente.
        </p>
      )}

      {/* Video results */}
      {videos.length > 0 && (
        <div className="space-y-2 max-h-80 overflow-y-auto">
          {videos.map(video => (
            <button
              key={video.id}
              type="button"
              onClick={() => {
                setManualUrl(video.url)
                onSelect(video.url)
              }}
              className={`w-full flex gap-3 p-2 rounded-lg text-left transition-colors ${
                manualUrl === video.url
                  ? 'bg-green-50 dark:bg-green-900/20 border border-green-300 dark:border-green-700'
                  : 'hover:bg-gray-50 dark:hover:bg-gray-800 border border-transparent'
              }`}
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={video.thumbnail}
                alt={video.title}
                className="w-32 h-20 object-cover rounded flex-shrink-0"
              />
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium text-gray-900 dark:text-white line-clamp-2">
                  {video.title}
                </p>
                <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                  {video.channelTitle} &middot; {video.duration} &middot; {formatViews(video.viewCount)} views
                </p>
              </div>
            </button>
          ))}
        </div>
      )}

      {searched && videos.length === 0 && configured && (
        <p className="text-sm text-gray-500 dark:text-gray-400">
          No se encontraron videos. Intenta con otro titulo o ingresa la URL manualmente.
        </p>
      )}
    </div>
  )
}

function formatViews(count: string): string {
  const n = parseInt(count)
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000) return `${(n / 1_000).toFixed(1)}K`
  return count
}
