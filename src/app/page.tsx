import Link from 'next/link'

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white dark:from-gray-900 dark:to-gray-800">
      {/* Header */}
      <header className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <nav className="flex justify-between items-center">
          <div className="text-2xl font-bold text-gray-900 dark:text-white">
            EduPlatform
          </div>
          <div className="flex gap-4">
            <Link
              href="/login"
              className="px-4 py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors"
            >
              Iniciar sesion
            </Link>
            <Link
              href="/register"
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Registrarse
            </Link>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="py-20 md:py-32 text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 dark:text-white mb-6">
            Aprende a tu ritmo,
            <br />
            <span className="text-blue-600">crece sin limites</span>
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-400 mb-8 max-w-2xl mx-auto">
            Accede a cursos de alta calidad, sigue tu progreso y alcanza tus metas
            de aprendizaje con nuestra plataforma educativa.
          </p>
          <div className="flex gap-4 justify-center">
            <Link
              href="/courses"
              className="px-8 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-lg font-medium"
            >
              Explorar cursos
            </Link>
            <Link
              href="/register"
              className="px-8 py-3 border border-gray-300 dark:border-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors text-lg font-medium"
            >
              Crear cuenta gratis
            </Link>
          </div>
        </div>

        {/* Features */}
        <div className="py-20 grid md:grid-cols-3 gap-8">
          <div className="text-center p-6">
            <div className="w-16 h-16 bg-blue-100 dark:bg-blue-900/30 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-3xl">📚</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Cursos de calidad
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Contenido creado por expertos en cada area de conocimiento.
            </p>
          </div>
          <div className="text-center p-6">
            <div className="w-16 h-16 bg-green-100 dark:bg-green-900/30 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-3xl">📈</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Seguimiento de progreso
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Monitorea tu avance y celebra cada logro en tu camino.
            </p>
          </div>
          <div className="text-center p-6">
            <div className="w-16 h-16 bg-purple-100 dark:bg-purple-900/30 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <span className="text-3xl">🎯</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Aprende a tu ritmo
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Sin presiones, avanza cuando puedas y donde quieras.
            </p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 border-t border-gray-200 dark:border-gray-800">
        <p className="text-center text-gray-500 dark:text-gray-400">
          EduPlatform - Plataforma de aprendizaje
        </p>
      </footer>
    </div>
  )
}
