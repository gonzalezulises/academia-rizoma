module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // Nueva funcionalidad
        'fix',      // Correccion de bug
        'docs',     // Documentacion
        'style',    // Formateo, sin cambios de codigo
        'refactor', // Refactorizacion
        'perf',     // Mejora de rendimiento
        'test',     // Tests
        'chore',    // Mantenimiento
        'revert',   // Revertir cambios
        'ci',       // CI/CD
        'build'     // Build
      ]
    ]
  }
};
