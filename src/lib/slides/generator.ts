/**
 * PPTX generator using pptxgenjs with Rizoma branding.
 * Generates presentations compatible with Google Slides.
 */

import PptxGenJS from 'pptxgenjs'
import type { SlideContent, ParsedLesson } from './markdown-parser'

// Rizoma brand colors
const COLORS = {
  darkBg: '0A0F1A',
  green: '289448',
  greenLight: 'E8F5E9',
  greenAccent: '34C759',
  white: 'FFFFFF',
  black: '000000',
  gray: '666666',
  grayLight: 'F5F5F5',
  grayDark: '333333',
  codeBg: '1E1E1E',
  codeText: 'D4D4D4',
  tableHeaderBg: '289448',
  tableAltRow: 'F0F8F0',
}

const FONTS = {
  heading: 'Calibri',
  body: 'Calibri',
  mono: 'Courier New',
}

interface QuizQuestion {
  question: string
  options: { id: string; text: string }[]
  correctId: string
  explanation?: string
}

export interface GenerateOptions {
  courseTitle: string
  moduleTitle: string
  moduleNumber: number
  lessons: ParsedLesson[]
  quizzes?: QuizQuestion[]
}

export async function generatePptx(options: GenerateOptions): Promise<Buffer> {
  const { courseTitle, moduleTitle, moduleNumber, lessons, quizzes } = options

  const pptx = new PptxGenJS()
  pptx.author = 'Rizoma'
  pptx.company = 'Rizoma'
  pptx.title = `${courseTitle} - ${moduleTitle}`
  pptx.subject = moduleTitle
  pptx.layout = 'LAYOUT_WIDE' // 13.33 x 7.5 inches

  // 1. Title slide
  addTitleSlide(pptx, courseTitle, moduleTitle, moduleNumber)

  // 2. Lesson slides
  for (const lesson of lessons) {
    // Lesson separator
    addLessonSeparator(pptx, lesson.lessonNumber, lesson.lessonTitle)

    // Content slides
    for (const slide of lesson.slides) {
      addSlide(pptx, slide)
    }
  }

  // 3. Quiz review slides
  if (quizzes && quizzes.length > 0) {
    addLessonSeparator(pptx, 0, 'Revisión de conceptos')
    for (const quiz of quizzes) {
      addQuizSlide(pptx, quiz)
    }
  }

  // 4. Closing slide
  addClosingSlide(pptx, moduleTitle)

  // Generate buffer
  const data = await pptx.write({ outputType: 'nodebuffer' })
  return data as Buffer
}

function addTitleSlide(pptx: PptxGenJS, courseTitle: string, moduleTitle: string, moduleNumber: number) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.darkBg }

  // Green accent line at top
  slide.addShape(pptx.ShapeType.rect, {
    x: 0, y: 0, w: 13.33, h: 0.06,
    fill: { color: COLORS.green },
  })

  // "Rizoma" brand
  slide.addText('Rizoma', {
    x: 0.8, y: 0.6, w: 5, h: 0.5,
    fontSize: 14,
    fontFace: FONTS.heading,
    color: COLORS.greenAccent,
    bold: true,
  })

  // Module number badge
  slide.addText(`MÓDULO ${moduleNumber}`, {
    x: 0.8, y: 2.0, w: 3, h: 0.5,
    fontSize: 14,
    fontFace: FONTS.heading,
    color: COLORS.greenAccent,
    bold: true,
    charSpacing: 3,
  })

  // Module title
  slide.addText(moduleTitle, {
    x: 0.8, y: 2.6, w: 10, h: 1.5,
    fontSize: 36,
    fontFace: FONTS.heading,
    color: COLORS.white,
    bold: true,
    lineSpacing: 42,
  })

  // Course name
  slide.addText(courseTitle, {
    x: 0.8, y: 4.5, w: 10, h: 0.5,
    fontSize: 16,
    fontFace: FONTS.body,
    color: COLORS.gray,
  })

  // Bottom accent line
  slide.addShape(pptx.ShapeType.rect, {
    x: 0.8, y: 6.8, w: 2, h: 0.04,
    fill: { color: COLORS.green },
  })

  // URL
  slide.addText('rizo.ma/academia', {
    x: 0.8, y: 6.95, w: 5, h: 0.4,
    fontSize: 11,
    fontFace: FONTS.body,
    color: COLORS.gray,
  })
}

function addLessonSeparator(pptx: PptxGenJS, lessonNumber: number, lessonTitle: string) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.darkBg }

  // Green vertical bar
  slide.addShape(pptx.ShapeType.rect, {
    x: 0.8, y: 2.5, w: 0.06, h: 2,
    fill: { color: COLORS.green },
  })

  if (lessonNumber > 0) {
    // Lesson number
    slide.addText(`LECCIÓN ${lessonNumber}`, {
      x: 1.2, y: 2.6, w: 10, h: 0.5,
      fontSize: 14,
      fontFace: FONTS.heading,
      color: COLORS.greenAccent,
      bold: true,
      charSpacing: 3,
    })
  }

  // Lesson title
  slide.addText(lessonTitle, {
    x: 1.2, y: lessonNumber > 0 ? 3.2 : 2.8, w: 10, h: 1.2,
    fontSize: 28,
    fontFace: FONTS.heading,
    color: COLORS.white,
    bold: true,
  })
}

function addSlide(pptx: PptxGenJS, slideContent: SlideContent) {
  switch (slideContent.type) {
    case 'content':
      addContentSlide(pptx, slideContent)
      break
    case 'code':
      addCodeSlide(pptx, slideContent)
      break
    case 'quote':
      addQuoteSlide(pptx, slideContent)
      break
    case 'table':
      addTableSlide(pptx, slideContent)
      break
  }
}

function addContentSlide(pptx: PptxGenJS, content: SlideContent) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.white }

  // Green left bar
  slide.addShape(pptx.ShapeType.rect, {
    x: 0, y: 0, w: 0.06, h: 7.5,
    fill: { color: COLORS.green },
  })

  let yPos = 0.6

  // Title
  if (content.title) {
    slide.addText(content.title, {
      x: 0.8, y: yPos, w: 11.5, h: 0.8,
      fontSize: 24,
      fontFace: FONTS.heading,
      color: COLORS.grayDark,
      bold: true,
    })
    yPos += 1.0
  }

  // Bullets / text
  if (content.bullets && content.bullets.length > 0) {
    const fontSize = content.bullets.length > 6 ? 14 : 16
    const textItems = content.bullets.map(b => ({
      text: b,
      options: {
        bullet: { code: '2022' }, // bullet dot
        fontSize,
        fontFace: FONTS.body,
        color: COLORS.grayDark,
        lineSpacing: fontSize + 8,
        paraSpaceBefore: 4,
      },
    }))

    slide.addText(textItems, {
      x: 0.8, y: yPos, w: 11.5, h: 7.5 - yPos - 0.5,
      valign: 'top',
    })
  }
}

function addCodeSlide(pptx: PptxGenJS, content: SlideContent) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.codeBg }

  let yPos = 0.4

  // Language badge
  if (content.language && content.language !== 'text') {
    slide.addText(content.language.toUpperCase(), {
      x: 0.6, y: yPos, w: 1.5, h: 0.35,
      fontSize: 10,
      fontFace: FONTS.mono,
      color: COLORS.codeBg,
      fill: { color: COLORS.greenAccent },
      bold: true,
      align: 'center',
      rectRadius: 0.05,
    })
    yPos += 0.6
  }

  // Title above code (if present)
  if (content.title) {
    slide.addText(content.title, {
      x: 0.6, y: yPos, w: 12, h: 0.6,
      fontSize: 18,
      fontFace: FONTS.heading,
      color: COLORS.white,
      bold: true,
    })
    yPos += 0.8
  }

  // Code content
  if (content.code) {
    // Truncate very long code blocks
    const codeLines = content.code.split('\n')
    const displayCode = codeLines.length > 25
      ? codeLines.slice(0, 25).join('\n') + '\n# ...'
      : content.code

    slide.addText(displayCode, {
      x: 0.6, y: yPos, w: 12, h: 7.5 - yPos - 0.4,
      fontSize: 12,
      fontFace: FONTS.mono,
      color: COLORS.codeText,
      valign: 'top',
      lineSpacing: 18,
    })
  }
}

function addQuoteSlide(pptx: PptxGenJS, content: SlideContent) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.white }

  // Light green tint area
  slide.addShape(pptx.ShapeType.rect, {
    x: 0.5, y: 1.0, w: 12.33, h: 5.5,
    fill: { color: COLORS.greenLight },
    rectRadius: 0.15,
  })

  // Large quote mark
  slide.addText('\u201C', {
    x: 1.0, y: 1.2, w: 1, h: 1.2,
    fontSize: 72,
    fontFace: 'Georgia',
    color: COLORS.green,
    bold: true,
  })

  // Quote text
  if (content.quote) {
    slide.addText(content.quote, {
      x: 1.5, y: 2.5, w: 10, h: 2.5,
      fontSize: 20,
      fontFace: 'Georgia',
      color: COLORS.grayDark,
      italic: true,
      lineSpacing: 30,
      valign: 'top',
    })
  }

  // Author
  if (content.quoteAuthor) {
    slide.addText(`— ${content.quoteAuthor}`, {
      x: 1.5, y: 5.2, w: 10, h: 0.5,
      fontSize: 14,
      fontFace: FONTS.body,
      color: COLORS.gray,
    })
  }
}

function addTableSlide(pptx: PptxGenJS, content: SlideContent) {
  if (!content.tableHeaders || !content.tableRows) return

  const slide = pptx.addSlide()
  slide.background = { color: COLORS.white }

  // Green left bar
  slide.addShape(pptx.ShapeType.rect, {
    x: 0, y: 0, w: 0.06, h: 7.5,
    fill: { color: COLORS.green },
  })

  let yPos = 0.6

  // Title
  if (content.title) {
    slide.addText(content.title, {
      x: 0.8, y: yPos, w: 11.5, h: 0.8,
      fontSize: 24,
      fontFace: FONTS.heading,
      color: COLORS.grayDark,
      bold: true,
    })
    yPos += 1.0
  }

  // Build table rows
  const headerRow = content.tableHeaders.map(h => ({
    text: h,
    options: {
      bold: true,
      color: COLORS.white,
      fill: { color: COLORS.tableHeaderBg },
      fontSize: 12,
      fontFace: FONTS.body,
    },
  }))

  const dataRows = content.tableRows.map((row, rowIdx) =>
    row.map(cell => ({
      text: cell,
      options: {
        color: COLORS.grayDark,
        fill: { color: rowIdx % 2 === 0 ? COLORS.white : COLORS.tableAltRow },
        fontSize: 11,
        fontFace: FONTS.body,
      },
    }))
  )

  const colW = Math.min(3, 11.5 / content.tableHeaders.length)

  slide.addTable([headerRow, ...dataRows], {
    x: 0.8,
    y: yPos,
    w: 11.5,
    colW,
    border: { type: 'solid', pt: 0.5, color: 'E0E0E0' },
    autoPage: true,
    autoPageRepeatHeader: true,
  })
}

function addQuizSlide(pptx: PptxGenJS, quiz: QuizQuestion) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.white }

  // Green left bar
  slide.addShape(pptx.ShapeType.rect, {
    x: 0, y: 0, w: 0.06, h: 7.5,
    fill: { color: COLORS.green },
  })

  // Question
  slide.addText(quiz.question, {
    x: 0.8, y: 0.6, w: 11.5, h: 1.2,
    fontSize: 20,
    fontFace: FONTS.heading,
    color: COLORS.grayDark,
    bold: true,
    valign: 'top',
  })

  // Options
  const labels = ['A', 'B', 'C', 'D', 'E', 'F']
  let yPos = 2.0
  for (let i = 0; i < quiz.options.length && i < labels.length; i++) {
    const opt = quiz.options[i]
    const isCorrect = opt.id === quiz.correctId

    // Option badge
    slide.addText(labels[i], {
      x: 0.8, y: yPos, w: 0.45, h: 0.45,
      fontSize: 14,
      fontFace: FONTS.heading,
      color: isCorrect ? COLORS.white : COLORS.grayDark,
      fill: { color: isCorrect ? COLORS.green : COLORS.grayLight },
      bold: true,
      align: 'center',
      valign: 'middle',
      rectRadius: 0.05,
    })

    // Option text
    slide.addText(opt.text, {
      x: 1.5, y: yPos, w: 10, h: 0.45,
      fontSize: 14,
      fontFace: FONTS.body,
      color: isCorrect ? COLORS.green : COLORS.grayDark,
      bold: isCorrect,
      valign: 'middle',
    })

    yPos += 0.65
  }

  // Explanation
  if (quiz.explanation) {
    yPos += 0.3
    slide.addShape(pptx.ShapeType.rect, {
      x: 0.8, y: yPos, w: 11.5, h: 0.02,
      fill: { color: 'E0E0E0' },
    })
    yPos += 0.2

    slide.addText(quiz.explanation, {
      x: 0.8, y: yPos, w: 11.5, h: 7.5 - yPos - 0.3,
      fontSize: 12,
      fontFace: FONTS.body,
      color: COLORS.gray,
      italic: true,
      valign: 'top',
    })
  }
}

function addClosingSlide(pptx: PptxGenJS, moduleTitle: string) {
  const slide = pptx.addSlide()
  slide.background = { color: COLORS.darkBg }

  // Green accent line
  slide.addShape(pptx.ShapeType.rect, {
    x: 5.5, y: 2.2, w: 2.33, h: 0.04,
    fill: { color: COLORS.green },
  })

  // "Módulo completado"
  slide.addText('Módulo completado', {
    x: 1, y: 2.5, w: 11.33, h: 1,
    fontSize: 32,
    fontFace: FONTS.heading,
    color: COLORS.white,
    bold: true,
    align: 'center',
  })

  // Module title
  slide.addText(moduleTitle, {
    x: 1, y: 3.5, w: 11.33, h: 0.8,
    fontSize: 18,
    fontFace: FONTS.body,
    color: COLORS.gray,
    align: 'center',
  })

  // Rizoma branding
  slide.addText('Rizoma', {
    x: 1, y: 5.2, w: 11.33, h: 0.6,
    fontSize: 16,
    fontFace: FONTS.heading,
    color: COLORS.greenAccent,
    bold: true,
    align: 'center',
  })

  // URL
  slide.addText('rizo.ma/academia', {
    x: 1, y: 5.8, w: 11.33, h: 0.5,
    fontSize: 12,
    fontFace: FONTS.body,
    color: COLORS.gray,
    align: 'center',
  })
}
