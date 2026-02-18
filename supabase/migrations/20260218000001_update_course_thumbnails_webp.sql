-- Update course thumbnails from SVG to WebP hero images
UPDATE courses SET thumbnail_url = '/images/courses/metricas-agiles-hero.webp'
WHERE id = 'ae000000-0000-0000-0000-000000000001';

UPDATE courses SET thumbnail_url = '/images/courses/decisiones-basadas-datos-hero.webp'
WHERE id = 'db000000-0000-0000-0000-000000000001';
