import type {
  ParsedContent,
  ContentSegment,
  ParsedEmbed,
  EmbedType
} from '@/types/exercises'

// Regex patterns for embeds
// Format: <!-- exercise:exercise-id -->
// Format: <!-- dataset:dataset-id -->
// Format: <!-- colab:notebook-id -->
const EMBED_PATTERN = /<!--\s*(exercise|dataset|colab):([a-zA-Z0-9_-]+)\s*-->/g

/**
 * Parse markdown content and extract embeds
 * Returns segments of markdown and embed references
 */
export function parseEmbeds(markdown: string): ParsedContent {
  const segments: ContentSegment[] = []
  const embeds: ParsedEmbed[] = []

  let lastIndex = 0
  let match: RegExpExecArray | null

  // Reset regex state
  EMBED_PATTERN.lastIndex = 0

  while ((match = EMBED_PATTERN.exec(markdown)) !== null) {
    const embedType = match[1] as EmbedType
    const embedId = match[2]
    const matchStart = match.index
    const matchEnd = match.index + match[0].length

    // Add markdown content before this embed
    if (matchStart > lastIndex) {
      const content = markdown.slice(lastIndex, matchStart).trim()
      if (content) {
        segments.push({
          type: 'markdown',
          content
        })
      }
    }

    // Create embed reference
    const embed: ParsedEmbed = {
      type: embedType,
      id: embedId,
      raw: match[0]
    }

    embeds.push(embed)
    segments.push({
      type: 'embed',
      content: match[0],
      embed
    })

    lastIndex = matchEnd
  }

  // Add remaining markdown content
  if (lastIndex < markdown.length) {
    const content = markdown.slice(lastIndex).trim()
    if (content) {
      segments.push({
        type: 'markdown',
        content
      })
    }
  }

  return { segments, embeds }
}

/**
 * Check if content has embeds
 */
export function hasEmbeds(markdown: string): boolean {
  EMBED_PATTERN.lastIndex = 0
  return EMBED_PATTERN.test(markdown)
}
