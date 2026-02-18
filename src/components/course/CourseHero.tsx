// Deterministic generative hero for courses without thumbnails.
// Pure server component — no state, no effects, SSR-optimal.

interface CourseHeroProps {
  title: string
  slug?: string
  size?: 'card' | 'detail' | 'banner'
  className?: string
}

// Simple deterministic hash from string
function hashString(str: string): number {
  let hash = 5381
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) + hash + str.charCodeAt(i)) | 0
  }
  return Math.abs(hash)
}

const COLOR_PAIRS = [
  { from: '#289448', to: '#1FACC0' }, // green → cyan
  { from: '#1F7038', to: '#3FC5D6' }, // dark green → light cyan
  { from: '#34A856', to: '#178A9A' }, // light green → dark cyan
  { from: '#1FACC0', to: '#289448' }, // cyan → green
  { from: '#178A9A', to: '#34A856' }, // dark cyan → light green
  { from: '#289448', to: '#2b5672' }, // green → blue
]

const SIZE_MAP = {
  card: 'h-48',
  detail: 'h-64',
  banner: 'h-full',
}

function getPatternSvg(index: number, id: string, color: string): string {
  const patterns = [
    // Network nodes
    `<pattern id="${id}" width="60" height="60" patternUnits="userSpaceOnUse">
      <circle cx="30" cy="30" r="3" fill="${color}" opacity="0.4"/>
      <circle cx="0" cy="0" r="2" fill="${color}" opacity="0.3"/>
      <circle cx="60" cy="0" r="2" fill="${color}" opacity="0.3"/>
      <circle cx="0" cy="60" r="2" fill="${color}" opacity="0.3"/>
      <circle cx="60" cy="60" r="2" fill="${color}" opacity="0.3"/>
      <line x1="0" y1="0" x2="30" y2="30" stroke="${color}" stroke-width="0.5" opacity="0.2"/>
      <line x1="60" y1="0" x2="30" y2="30" stroke="${color}" stroke-width="0.5" opacity="0.2"/>
      <line x1="0" y1="60" x2="30" y2="30" stroke="${color}" stroke-width="0.5" opacity="0.2"/>
      <line x1="60" y1="60" x2="30" y2="30" stroke="${color}" stroke-width="0.5" opacity="0.2"/>
    </pattern>`,
    // Hexagonal grid
    `<pattern id="${id}" width="56" height="100" patternUnits="userSpaceOnUse">
      <path d="M28 66L0 50L0 16L28 0L56 16L56 50L28 66Z" fill="none" stroke="${color}" stroke-width="0.5" opacity="0.25"/>
      <path d="M28 100L0 84L0 50L28 34L56 50L56 84L28 100Z" fill="none" stroke="${color}" stroke-width="0.5" opacity="0.15"/>
    </pattern>`,
    // Circuit board
    `<pattern id="${id}" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M0 20h15M25 20h15M20 0v15M20 25v15" stroke="${color}" stroke-width="0.8" opacity="0.25"/>
      <rect x="17" y="17" width="6" height="6" rx="1" fill="${color}" opacity="0.2"/>
      <circle cx="0" cy="20" r="1.5" fill="${color}" opacity="0.3"/>
      <circle cx="40" cy="20" r="1.5" fill="${color}" opacity="0.3"/>
      <circle cx="20" cy="0" r="1.5" fill="${color}" opacity="0.3"/>
      <circle cx="20" cy="40" r="1.5" fill="${color}" opacity="0.3"/>
    </pattern>`,
    // Wave
    `<pattern id="${id}" width="80" height="20" patternUnits="userSpaceOnUse">
      <path d="M0 10 Q20 0 40 10 Q60 20 80 10" fill="none" stroke="${color}" stroke-width="0.8" opacity="0.25"/>
      <path d="M0 15 Q20 5 40 15 Q60 25 80 15" fill="none" stroke="${color}" stroke-width="0.5" opacity="0.15"/>
    </pattern>`,
    // Dot matrix
    `<pattern id="${id}" width="20" height="20" patternUnits="userSpaceOnUse">
      <circle cx="10" cy="10" r="1.5" fill="${color}" opacity="0.3"/>
      <circle cx="0" cy="0" r="1" fill="${color}" opacity="0.2"/>
      <circle cx="20" cy="0" r="1" fill="${color}" opacity="0.2"/>
      <circle cx="0" cy="20" r="1" fill="${color}" opacity="0.2"/>
      <circle cx="20" cy="20" r="1" fill="${color}" opacity="0.2"/>
    </pattern>`,
    // Geometric mesh
    `<pattern id="${id}" width="48" height="48" patternUnits="userSpaceOnUse">
      <path d="M0 0L24 12L48 0M0 24L24 36L48 24M0 48L24 36L48 48" fill="none" stroke="${color}" stroke-width="0.6" opacity="0.2"/>
      <path d="M24 12L24 36" stroke="${color}" stroke-width="0.6" opacity="0.15"/>
      <circle cx="24" cy="12" r="2" fill="${color}" opacity="0.25"/>
      <circle cx="24" cy="36" r="2" fill="${color}" opacity="0.25"/>
    </pattern>`,
  ]
  return patterns[index % patterns.length]
}

function buildSvg(gradientId: string, patternId: string, gradientAngle: number, colorPair: { from: string; to: string }, patternIndex: number): string {
  const patternSvg = getPatternSvg(patternIndex, patternId, '#FFFFFF')
  return `<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" preserveAspectRatio="xMidYMid slice">
    <defs>
      <linearGradient id="${gradientId}" gradientTransform="rotate(${gradientAngle})">
        <stop offset="0%" stop-color="${colorPair.from}"/>
        <stop offset="100%" stop-color="${colorPair.to}"/>
      </linearGradient>
      ${patternSvg}
    </defs>
    <rect width="100%" height="100%" fill="url(#${gradientId})"/>
    <rect width="100%" height="100%" fill="url(#${patternId})"/>
  </svg>`
}

export default function CourseHero({ title, slug, size = 'card', className = '' }: CourseHeroProps) {
  const seed = slug || title
  const hash = hashString(seed)

  const colorPair = COLOR_PAIRS[hash % COLOR_PAIRS.length]
  const patternIndex = (hash >> 4) % 6
  const gradientAngle = (hash >> 8) % 360

  const patternId = `hero-${hash.toString(36)}`
  const gradientId = `grad-${hash.toString(36)}`

  const svgHtml = buildSvg(gradientId, patternId, gradientAngle, colorPair, patternIndex)

  return (
    <div className={`${SIZE_MAP[size]} w-full relative overflow-hidden ${className}`}>
      <div
        className="absolute inset-0"
        dangerouslySetInnerHTML={{ __html: svgHtml }}
      />
      {size !== 'banner' && (
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-white text-4xl font-bold drop-shadow-lg">
            {title.charAt(0)}
          </span>
        </div>
      )}
    </div>
  )
}
