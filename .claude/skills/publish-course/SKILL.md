---
name: publish-course
description: Validate and publish course content to academia-rizoma with exercises, quizzes, and Supabase migration
disable-model-invocation: true
argument-hint: '<path-to-course-files-or-zip>'
---

# Publish Course Content

Validate and publish course content from `$ARGUMENTS` to `content/courses/`.

**Before starting:** Read `CLAUDE_COURSE_GUIDE.md` for full context on the exercise system architecture.

---

## Step 1: Extract and inventory source files

- If `$ARGUMENTS` is a `.zip` file, extract to `/tmp/course-import/`
- If it's a directory, read all files recursively
- If it's individual files, collect them

**Inventory checklist** — report what was found vs. what's expected:

| File type | Pattern | Required |
|-----------|---------|----------|
| Course definition | `course.yaml` | YES |
| Module definitions | `*/module.yaml` or `module-*/module.yaml` | YES (1+ per course) |
| Lessons | `*.md` inside `lessons/` dirs | YES (1+ per module) |
| Exercises | `*.yaml` inside `exercises/` dirs | YES (1+ per module) |
| Course state | `COURSE_STATE.yaml` | NO (generated if missing) |
| Diagrams | `*.mmd` or `*.mermaid` | NO |
| Images | `*.png`, `*.jpg`, `*.webp`, `*.svg` | NO |
| Datasets | `*.csv` | NO |

Report: "Found X modules, Y lessons, Z exercises. Missing: [list]"

---

## Step 2: Validate course.yaml

Validate against the canonical schema (see `schemas/course.yaml` in this skill directory):

**Required fields:**
- `id` — string, must match `slug`
- `title` — string
- `description` — string or multiline YAML
- `slug` — kebab-case (`/^[a-z0-9]+(-[a-z0-9]+)*$/`)
- `modules[]` — array with at least 1 entry; each entry needs `id`, `title`, `description`, `order`

**Required with defaults:**
- `is_published` — boolean (default: `false`)
- `exercise_config.default_runtime` — `pyodide` | `jupyterlite` | `colab` (default: `pyodide`)

**Optional fields:**
- `thumbnail_url`, `instructor_id`, `prerequisites[]`, `tags[]`, `estimated_duration_hours`, `difficulty`, `source`
- `exercise_config.allow_solution_view`, `exercise_config.max_attempts`

**Validations:**
- Every `modules[].id` must have a corresponding directory with a `module.yaml`
- `modules[].order` values must be sequential starting from 1
- `slug` must be valid kebab-case

---

## Step 3: Validate module.yaml (per module)

Each `module.yaml` must have:

**Required fields:**
- `id` — string matching the directory name (e.g., `module-01`)
- `title` — string
- `order` — integer matching position in `course.yaml`

**Required array:**
- `lessons[]` — each entry needs:
  - `id` — string (e.g., `lesson-01-01`)
  - `file` — relative path to `.md` file (e.g., `lessons/01-primeros-pasos.md`)
  - `title` — string

**Optional per lesson:**
- `type` (default: `text`), `order`, `duration_minutes`, `exercises[]`

**Optional array:**
- `exercises[]` — each entry needs `id`, `file`, optionally `lesson_id`

**Validations:**
- Every `lessons[].file` must point to an existing `.md` file
- Every `exercises[].file` must point to an existing `.yaml` file
- If `exercises[]` references a `lesson_id`, that lesson must exist in `lessons[]`

---

## Step 4: Validate exercise YAML (per exercise)

Load `src/types/exercises.ts` to confirm the canonical TypeScript interfaces. Validate each exercise YAML against its type:

### code-python

Required fields (see `CodeExercise` interface):
- `id` — string, unique across the course
- `type: code-python`
- `title` — string
- `description` — string
- `instructions` — string (multiline OK)
- `difficulty` — `beginner` | `intermediate` | `advanced`
- `estimated_time_minutes` — integer
- `points` — integer
- `starter_code` — string (must be syntactically plausible Python — no obvious `SyntaxError`)
- `solution_code` — string
- `test_cases[]` — array, at least 1 entry:
  - `id`, `name`, `test_code` (must contain at least one `assert`), `points`

Optional: `runtime_tier`, `hints[]`, `tags[]`, `required_packages[]`, `datasets[]`, `forbidden_keywords[]`, `required_keywords[]`, `comprehension_questions[]`, `ui_config`

### sql

Required fields (see `SQLExercise` interface):
- `id`, `type: sql`, `title`, `description`, `instructions`
- `difficulty`, `estimated_time_minutes`, `points`
- `schema_id` — references a file in `content/shared/schemas/{schema_id}.sql`
- `starter_code` — string
- `solution_query` — string (note: field is `solution_query`, NOT `solution_code`)

Optional: `expected_output[]` (array of objects), `test_cases[]`, `datasets[]`, `hints[]`, `tags[]`

**Validation:** If `schema_id` references a shared schema, verify the `.sql` file exists or will be created.

### quiz

Required fields (see `QuizExercise` interface):
- `id`, `type: quiz`, `title`, `description`, `instructions`
- `difficulty`, `estimated_time_minutes`, `points`
- `questions[]` — at least 1 question, each with:
  - `id` — string
  - `question` — string
  - `type` — `mcq` | `true_false` | `multiple_select` | `multiple_choice`
  - `options[]` — at least 2 options, each with `id` and `text`
  - `correct` — string (option `id`) or string[] (for `multiple_select`)
  - `points` — integer

**Validation:**
- `correct` must reference valid option `id`(s) within the same question
- At least 2 options per question (3+ recommended)
- For `true_false`, exactly 2 options

Optional per question: `bloom_level`, `feedback_correct`, `feedback_incorrect`, `explanation`
Optional per quiz: `config` (with `passing_score`, `show_feedback`, `randomize_questions`, `allow_retry`)

### colab

Required fields (see `ColabExercise` interface):
- `id`, `type: colab`, `title`, `description`, `instructions`
- `difficulty`, `estimated_time_minutes`, `points`
- `colab_url` — valid Google Colab or GitHub URL
- `notebook_name` — string
- `completion_criteria` — string describing what constitutes completion

Optional: `github_url`, `manual_completion`, `hints[]`, `tags[]`

**Validation:** `colab_url` must be a valid URL (starts with `https://colab.research.google.com/` or `https://github.com/`)

---

## Step 5: Validate lesson markdown

For each `.md` lesson file:

1. **Exercise embeds** — every `<!-- exercise:id -->` must have a corresponding `.yaml` exercise file with that exact `id`
2. **Heading hierarchy** — headings must not skip levels (e.g., `##` then `####` is invalid; `##` then `###` is OK)
3. **No broken internal links** — any `[text](path)` links to other lessons must reference existing files
4. **Code blocks** — verify language tags on fenced code blocks (` ```python `, ` ```sql `, etc.)

**4C model check per module** (warn if missing, don't block):
- At least 1 lesson with contextual/motivational content (Connection)
- At least 1 lesson with theory/explanation (Concepts)
- At least 1 practical exercise (`code-python` or `sql`) (Concrete Practice)
- At least 1 quiz exercise (Conclusions/evaluation)

Report: "Module X: Connection OK, Concepts OK, Practice OK (Y exercises), Quiz MISSING"

---

## Step 6: Validate COURSE_STATE.yaml

If `COURSE_STATE.yaml` exists in the source:

1. Verify `meta.course_id` matches `course.yaml` `id`/`slug`
2. Verify `exercises_registry` lists all exercises found in Step 4
3. Verify `learning_progression.concepts_introduced` covers concepts used in exercises
4. Verify `code_conventions` is consistent with code in exercises (variable names, import style)

If `COURSE_STATE.yaml` does NOT exist, generate an initial one with:
- `meta` section with course_id, last_updated (today), total_exercises_created
- `learning_progression` with `concepts_introduced` per module (inferred from exercise content)
- `code_conventions` with standard variable names from the reference template (see `schemas/course-state.yaml`)
- `exercises_registry` populated from all exercises found
- `pedagogical_style` section with defaults

Use `content/courses/data-analytics/COURSE_STATE.yaml` as the canonical reference template.

---

## Step 7: Process Mermaid diagrams

If `.mmd` or `.mermaid` files are present:

1. Extract each file (or extract ` ```mermaid ` blocks from `.mermaid.md` files into separate `.mmd` files in `/tmp/mermaid-render/`)
2. Render to SVG:
   ```
   npx @mermaid-js/mermaid-cli -i input.mmd -o output.svg -b transparent -q
   ```
3. Copy SVGs to `public/images/courses/{slug}/diagrams/`
4. Update references in lesson markdown:
   ```markdown
   ![Diagram description](/images/courses/{slug}/diagrams/filename.svg)
   ```

If no diagram files are present, skip this step.

---

## Step 8: Generate visual assets

### Hero image (course thumbnail)

If `course.yaml` has no `thumbnail_url` or the referenced file doesn't exist:

1. Create an HTML file in `/tmp/hero-images/` with a 1200x630 design:
   - Dark background (`#0a0f1a`) with subtle grid overlay
   - System font stack: `'SF Pro Display', -apple-system, system-ui, sans-serif`
   - Course title (bold, white, 36-44px)
   - Course description excerpt (14px, `rgba(255,255,255,0.45)`)
   - Difficulty badge in accent color
   - Module count and exercise count as data points
   - Accent color by difficulty:
     - **beginner**: `#27ae60` (green)
     - **intermediate**: `#2980b9` (blue)
     - **advanced**: `#8e44ad` (purple)
   - No images, no external fonts — pure HTML/CSS

2. Render with Playwright MCP tools:
   ```
   playwright_navigate → file:///tmp/hero-images/{slug}.html (width: 1200, height: 630, headless: true)
   playwright_screenshot → name: {slug}, savePng: true, width: 1200, height: 630, downloadsDir: /tmp/hero-images/output
   ```

3. Convert PNG to WebP:
   ```
   cwebp -q 85 /tmp/hero-images/output/{slug}-*.png -o public/images/courses/{slug}-thumbnail.webp
   ```

4. Update `course.yaml`: `thumbnail_url: /images/courses/{slug}-thumbnail.webp`

If `thumbnail_url` already points to an existing file, skip this step.

---

## Step 9: Copy content to repository

Destination: `content/courses/{slug}/`

**Target structure:**
```
content/courses/{slug}/
├── course.yaml
├── COURSE_STATE.yaml
├── module-01/
│   ├── module.yaml
│   ├── lessons/
│   │   ├── 01-leccion.md
│   │   └── 02-leccion.md
│   └── exercises/
│       ├── ex-01-01-nombre.yaml
│       └── ex-01-02-nombre.yaml
├── module-02/
│   └── ...
```

**Rules:**
- If `content/courses/{slug}/` already exists, ask user before overwriting: "Course '{slug}' already exists. Overwrite? [y/N]"
- Copy datasets to `content/shared/datasets/` if they don't already exist there
- Copy SQL schemas to `content/shared/schemas/` if referenced by exercises
- Preserve file permissions and line endings

---

## Step 10: Generate Supabase migration

Generate a migration SQL file at:
```
supabase/migrations/{YYYYMMDDHHMMSS}_seed_{slug}.sql
```

Use the timestamp format `YYYYMMDDHHMMSS` (e.g., `20260217120000`).

**UUID convention:** Generate deterministic UUIDs for the course using a prefix pattern:
- Course: `{XX}000000-0000-0000-0000-000000000001` where `XX` is a 2-letter abbreviation of the slug
- Modules: `{XX}{MM}0000-0000-0000-0000-000000000001` where `MM` is the module number (01-99)
- Lessons: `{XX}{MM}{LL}00-0000-0000-0000-000000000001` where `LL` is the lesson number

Look at existing migrations (e.g., `20251226000001_seed_data_analytics_course.sql`) for the exact pattern.

**SQL structure:**

```sql
-- =====================================================
-- Seed: Curso {title}
-- {N} modules, {M} lessons, {P} exercises
-- =====================================================

-- 1. Insert course
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published)
VALUES (
  '{course-uuid}',
  '{title}',
  '{description}',
  '{slug}',
  '{thumbnail_url}',
  false  -- Always start unpublished; admin enables manually
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  is_published = EXCLUDED.is_published;

-- 2. Insert modules
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  ('{module-uuid}', '{course-uuid}', '{module-title}', '{module-desc}', {order}, false)
  -- ... one row per module
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- 3. Insert lessons
INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required, video_url)
VALUES
  ('{lesson-uuid}', '{course-uuid}', '{module-uuid}', '{title}',
   'Ver archivo: content/courses/{slug}/{module-id}/lessons/{filename}.md',
   'text', {order}, {duration}, true, null)
  -- ... one row per lesson
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content;
```

**Notes:**
- Use `$CONTENT$...$CONTENT$` dollar quoting for multiline content
- Use `ON CONFLICT (id) DO UPDATE SET` for idempotency
- Set `is_published = false` — admin enables manually
- Lesson `content` points to the file path (the platform loads from filesystem first, DB second)

---

## Step 11: Verify build

Run in the academia-rizoma project root:

```bash
npm run build
```

- Must complete without errors
- Check that no TypeScript errors were introduced
- Verify the new course's file paths are accessible

If build fails, diagnose and report the error — do NOT modify source code to fix build issues without user approval.

---

## Step 12: Comprehensive report

Generate a final report with:

```
=== Course Publication Report ===

Course: {title} ({slug})
Status: PUBLISHED / VALIDATION FAILED

Content:
  - Modules: {N}
  - Lessons: {M}
  - Exercises: {P} ({python} Python, {sql} SQL, {quiz} Quiz, {colab} Colab)

Validations:
  [PASS] course.yaml schema valid
  [PASS] All module.yaml files valid
  [PASS] All exercise YAML files valid
  [PASS] All lesson markdown embeds resolved
  [PASS] 4C model coverage per module
  [PASS] COURSE_STATE.yaml consistent
  [WARN] Module 3 missing quiz exercise

Assets:
  - Hero image: public/images/courses/{slug}-thumbnail.webp ({size} KB)
  - Diagrams: {N} SVGs rendered

Migration:
  - File: supabase/migrations/{timestamp}_seed_{slug}.sql
  - Tables: courses (1 row), modules ({N} rows), lessons ({M} rows)

Next steps:
  1. Review content in content/courses/{slug}/
  2. Apply migration: source .env.local && supabase db push --linked
  3. Set is_published = true when ready
  4. Deploy: git push origin main
```

---

## Notes

- Never add dependencies to package.json — use `npx` for mermaid-cli
- Course content is in Spanish — do not translate unless explicitly asked
- The skill validates but does NOT auto-fix content — report issues for the author to correct
- Works with both AI-generated content (from `course-gen-service`) and manually written content
- Exercise field names must match TypeScript interfaces in `src/types/exercises.ts`
- The `COURSE_STATE.yaml` is critical for multi-session course creation — always preserve or generate it
- Close the Playwright browser after screenshots: `playwright_close`
- Quiz `correct` field uses option **IDs** (strings), not array indices
- SQL exercises use `solution_query` (not `solution_code`)
