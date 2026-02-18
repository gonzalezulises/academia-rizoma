/**
 * Markdown → Slide structure parser for PPTX generation.
 * Follows the same regex-based approach as embed-parser.ts.
 */

type SlideType = 'title' | 'lesson-separator' | 'content' | 'code' | 'quote' | 'table' | 'quiz' | 'closing'

export interface SlideContent {
  type: SlideType
  title?: string
  bullets?: string[]
  code?: string
  language?: string
  quote?: string
  quoteAuthor?: string
  tableHeaders?: string[]
  tableRows?: string[][]
  // Quiz fields
  question?: string
  options?: { id: string; text: string }[]
  correctId?: string
  explanation?: string
}

export interface ParsedLesson {
  lessonNumber: number
  lessonTitle: string
  slides: SlideContent[]
}

// Strip exercise/dataset/colab embeds
const EMBED_PATTERN = /<!--\s*(exercise|dataset|colab):[a-zA-Z0-9_-]+\s*-->/g

// Fenced code block: ```lang\n...\n```
const CODE_BLOCK_PATTERN = /^```(\w*)\n([\s\S]*?)^```/gm

// Blockquote: lines starting with >
const BLOCKQUOTE_LINE = /^>\s?(.*)$/

// Table row: | col | col | col |
const TABLE_ROW_PATTERN = /^\|(.+)\|$/

// Table separator: | --- | --- |
const TABLE_SEP_PATTERN = /^\|[\s:?-]+\|$/

// Horizontal rule
const HR_PATTERN = /^---+$/

/**
 * Parse a single markdown lesson into slide structures.
 */
export function parseLesson(
  markdown: string,
  lessonNumber: number,
  lessonTitle: string
): ParsedLesson {
  // Strip embeds
  const cleaned = markdown.replace(EMBED_PATTERN, '').trim()

  const slides: SlideContent[] = []

  // Split by ## headings (each becomes a slide)
  const sections = splitByHeadings(cleaned)

  for (const section of sections) {
    const sectionSlides = parseSection(section.title, section.body)
    slides.push(...sectionSlides)
  }

  return { lessonNumber, lessonTitle, slides }
}

interface Section {
  title: string
  body: string
}

function splitByHeadings(markdown: string): Section[] {
  const sections: Section[] = []
  const lines = markdown.split('\n')

  let currentTitle = ''
  let currentBody: string[] = []

  for (const line of lines) {
    // Match ## or ### headings (not # which is the lesson title)
    const headingMatch = line.match(/^#{2,3}\s+(.+)$/)
    if (headingMatch) {
      // Save previous section
      if (currentTitle || currentBody.length > 0) {
        sections.push({
          title: currentTitle,
          body: currentBody.join('\n').trim()
        })
      }
      currentTitle = headingMatch[1].trim()
      currentBody = []
    } else {
      // Skip # lesson title heading
      if (line.match(/^#\s+/) && sections.length === 0 && currentBody.length === 0) {
        continue
      }
      currentBody.push(line)
    }
  }

  // Push last section
  if (currentTitle || currentBody.length > 0) {
    sections.push({
      title: currentTitle,
      body: currentBody.join('\n').trim()
    })
  }

  return sections
}

/**
 * Parse a section body into one or more slides.
 * A section with mixed content (text + code, text + table) produces multiple slides.
 */
function parseSection(title: string, body: string): SlideContent[] {
  if (!body && !title) return []

  const slides: SlideContent[] = []

  // Extract code blocks first, replacing them with placeholders
  const codeBlocks: { language: string; code: string }[] = []
  const bodyWithPlaceholders = body.replace(CODE_BLOCK_PATTERN, (_, lang, code) => {
    codeBlocks.push({ language: lang || 'text', code: code.trim() })
    return `__CODE_BLOCK_${codeBlocks.length - 1}__`
  })

  // Split remaining content by code block placeholders
  const parts = bodyWithPlaceholders.split(/(__CODE_BLOCK_\d+__)/)

  let contentBullets: string[] = []

  for (const part of parts) {
    const codeMatch = part.match(/^__CODE_BLOCK_(\d+)__$/)
    if (codeMatch) {
      // Flush any accumulated text as a content slide
      if (contentBullets.length > 0 || (title && slides.length === 0)) {
        slides.push({
          type: 'content',
          title: slides.length === 0 ? title : undefined,
          bullets: contentBullets.length > 0 ? contentBullets : undefined,
        })
        contentBullets = []
      }

      const block = codeBlocks[parseInt(codeMatch[1])]
      slides.push({
        type: 'code',
        title: slides.length === 0 ? title : undefined,
        code: block.code,
        language: block.language,
      })
    } else {
      // Parse text content: extract bullets, quotes, tables
      const parsed = parseTextContent(part.trim())

      for (const item of parsed) {
        if (item.type === 'quote') {
          // Flush accumulated bullets
          if (contentBullets.length > 0 || (title && slides.length === 0)) {
            slides.push({
              type: 'content',
              title: slides.length === 0 ? title : undefined,
              bullets: contentBullets.length > 0 ? contentBullets : undefined,
            })
            contentBullets = []
          }
          slides.push({
            type: 'quote',
            quote: item.text,
            quoteAuthor: item.author,
          })
        } else if (item.type === 'table') {
          // Flush accumulated bullets
          if (contentBullets.length > 0 || (title && slides.length === 0)) {
            slides.push({
              type: 'content',
              title: slides.length === 0 ? title : undefined,
              bullets: contentBullets.length > 0 ? contentBullets : undefined,
            })
            contentBullets = []
          }
          slides.push({
            type: 'table',
            title: slides.length === 0 ? title : undefined,
            tableHeaders: item.headers,
            tableRows: item.rows,
          })
        } else if (item.type === 'bullet') {
          contentBullets.push(item.text)
        } else if (item.type === 'text' && item.text) {
          contentBullets.push(item.text)
        }
      }
    }
  }

  // Flush remaining bullets
  if (contentBullets.length > 0 || (title && slides.length === 0)) {
    slides.push({
      type: 'content',
      title: slides.length === 0 ? title : undefined,
      bullets: contentBullets.length > 0 ? contentBullets : undefined,
    })
  }

  return slides
}

type ParsedItem =
  | { type: 'text'; text: string }
  | { type: 'bullet'; text: string }
  | { type: 'quote'; text: string; author?: string }
  | { type: 'table'; headers: string[]; rows: string[][] }

function parseTextContent(text: string): ParsedItem[] {
  if (!text) return []

  const items: ParsedItem[] = []
  const lines = text.split('\n')

  let i = 0
  while (i < lines.length) {
    const line = lines[i]

    // Skip horizontal rules
    if (HR_PATTERN.test(line.trim())) {
      i++
      continue
    }

    // Blockquote
    if (BLOCKQUOTE_LINE.test(line.trim())) {
      const quoteLines: string[] = []
      while (i < lines.length && BLOCKQUOTE_LINE.test(lines[i].trim())) {
        const match = lines[i].trim().match(BLOCKQUOTE_LINE)
        if (match) quoteLines.push(match[1])
        i++
      }
      const fullQuote = quoteLines.join(' ').trim()
      // Try to extract author from "— Author" pattern
      const authorMatch = fullQuote.match(/^(.+?)(?:\s*[—–-]\s*(.+))$/)
      if (authorMatch && authorMatch[2]) {
        items.push({ type: 'quote', text: authorMatch[1].trim(), author: authorMatch[2].trim() })
      } else {
        items.push({ type: 'quote', text: fullQuote })
      }
      continue
    }

    // Table
    if (TABLE_ROW_PATTERN.test(line.trim())) {
      const tableLines: string[] = []
      while (i < lines.length && TABLE_ROW_PATTERN.test(lines[i].trim())) {
        tableLines.push(lines[i].trim())
        i++
      }
      // Need at least header + separator + 1 data row (or header + separator)
      if (tableLines.length >= 2) {
        const headers = parseTableRow(tableLines[0])
        // Skip separator line
        const dataStart = TABLE_SEP_PATTERN.test(tableLines[1]) ? 2 : 1
        const rows = tableLines.slice(dataStart).map(parseTableRow)
        items.push({ type: 'table', headers, rows })
      }
      continue
    }

    // Bullet/list items (- or * or numbered)
    const bulletMatch = line.match(/^\s*[-*]\s+(.+)$/) || line.match(/^\s*\d+\.\s+(.+)$/)
    if (bulletMatch) {
      items.push({ type: 'bullet', text: stripMarkdownFormatting(bulletMatch[1]) })
      i++
      continue
    }

    // Regular text paragraph
    const trimmed = line.trim()
    if (trimmed) {
      // Collect continuous text lines into a single paragraph
      const paraLines: string[] = [trimmed]
      i++
      while (
        i < lines.length &&
        lines[i].trim() &&
        !BLOCKQUOTE_LINE.test(lines[i].trim()) &&
        !TABLE_ROW_PATTERN.test(lines[i].trim()) &&
        !lines[i].match(/^\s*[-*]\s+/) &&
        !lines[i].match(/^\s*\d+\.\s+/) &&
        !HR_PATTERN.test(lines[i].trim()) &&
        !lines[i].match(/^__CODE_BLOCK_/)
      ) {
        paraLines.push(lines[i].trim())
        i++
      }
      const paragraph = stripMarkdownFormatting(paraLines.join(' '))
      if (paragraph) {
        items.push({ type: 'text', text: paragraph })
      }
      continue
    }

    i++
  }

  return items
}

function parseTableRow(row: string): string[] {
  return row
    .split('|')
    .slice(1, -1) // Remove leading/trailing empty from split
    .map(cell => stripMarkdownFormatting(cell.trim()))
}

/**
 * Strip common markdown formatting for plain text in slides.
 * Preserves semantic meaning while removing syntax.
 */
function stripMarkdownFormatting(text: string): string {
  return text
    .replace(/\*\*(.+?)\*\*/g, '$1')     // bold
    .replace(/\*(.+?)\*/g, '$1')          // italic
    .replace(/__(.+?)__/g, '$1')          // bold alt
    .replace(/_(.+?)_/g, '$1')            // italic alt
    .replace(/`(.+?)`/g, '$1')            // inline code
    .replace(/\[(.+?)\]\(.+?\)/g, '$1')   // links
    .replace(/!\[.*?\]\(.+?\)/g, '')       // images
    .trim()
}
