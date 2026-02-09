import Link from 'next/link'

export default function Home() {
  return (
    <div className="min-h-screen bg-cloud-dancer dark:bg-gray-900">
      {/* Header */}
      <header className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <nav className="flex justify-between items-center">
          <a href="https://www.rizo.ma/" className="flex items-center">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/images/brand/logo-plenos-color-optimized.png"
              alt="Rizoma Academia"
              className="h-10 w-auto dark:hidden"
            />
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src="/images/brand/logo-plenos-blanco-optimized.png"
              alt="Rizoma Academia"
              className="h-10 w-auto hidden dark:block"
            />
          </a>
          <div className="flex gap-4">
            <Link
              href="/login"
              className="px-4 py-2 text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors"
            >
              Iniciar sesión
            </Link>
            <Link
              href="/register"
              className="px-4 py-2 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark transition-colors"
            >
              Registrarse
            </Link>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="py-20 md:py-32 text-center">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-rizoma-green/10 rounded-full mb-6">
            <span className="w-2 h-2 bg-rizoma-green rounded-full animate-pulse"></span>
            <span className="text-sm text-rizoma-green font-medium">Plataforma de aprendizaje Rizoma</span>
          </div>
          <h1 className="text-4xl md:text-6xl font-bold text-gray-900 dark:text-white mb-6 font-serif">
            Aprende, crece,
            <br />
            <span className="text-rizoma-green">transforma</span>
          </h1>
          <p className="text-xl text-gray-600 dark:text-gray-400 mb-8 max-w-2xl mx-auto">
            Desarrolla las habilidades que tu organización necesita. Cursos prácticos
            en transformación organizacional, liderazgo y toma de decisiones.
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <Link
              href="/courses"
              className="px-8 py-3 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark transition-colors text-lg font-medium shadow-button"
            >
              Explorar cursos
            </Link>
            <Link
              href="/register"
              className="px-8 py-3 border-2 border-rizoma-green text-rizoma-green rounded-lg hover:bg-rizoma-green hover:text-white transition-colors text-lg font-medium"
            >
              Crear cuenta gratis
            </Link>
          </div>
        </div>

        {/* Features */}
        <div className="py-20 grid md:grid-cols-3 gap-8">
          <div className="bg-white dark:bg-gray-800 rounded-card p-8 shadow-card hover:shadow-card-hover transition-shadow">
            <div className="w-14 h-14 bg-rizoma-green/10 rounded-xl flex items-center justify-center mb-4">
              <svg className="w-7 h-7 text-rizoma-green" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Contenido práctico
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Cursos diseñados por expertos con enfoque en aplicación real e inmediata.
            </p>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-card p-8 shadow-card hover:shadow-card-hover transition-shadow">
            <div className="w-14 h-14 bg-rizoma-cyan/10 rounded-xl flex items-center justify-center mb-4">
              <svg className="w-7 h-7 text-rizoma-cyan" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Seguimiento de progreso
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Visualiza tu avance, completa quizzes y obtén certificaciones.
            </p>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-card p-8 shadow-card hover:shadow-card-hover transition-shadow">
            <div className="w-14 h-14 bg-rizoma-blue/10 rounded-xl flex items-center justify-center mb-4">
              <svg className="w-7 h-7 text-rizoma-blue" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              A tu ritmo
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Aprende cuando quieras, desde donde quieras. Sin presiones.
            </p>
          </div>
        </div>

        {/* CTA Section */}
        <div className="py-16 mb-12">
          <div className="bg-gradient-to-br from-rizoma-green to-rizoma-green-dark rounded-2xl p-12 text-center text-white">
            <h2 className="text-3xl md:text-4xl font-bold mb-4 font-serif">
              ¿Listo para transformar tu organización?
            </h2>
            <p className="text-lg text-white/90 mb-8 max-w-xl mx-auto">
              Únete a cientos de profesionales que ya están desarrollando las habilidades del futuro.
            </p>
            <Link
              href="/register"
              className="inline-block px-8 py-3 bg-white text-rizoma-green rounded-lg hover:bg-gray-100 transition-colors text-lg font-medium"
            >
              Comenzar ahora — Es gratis
            </Link>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <a href="https://www.rizo.ma/" className="flex items-center">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src="/images/brand/logo-plenos-color-optimized.png"
                alt="Rizoma"
                className="h-7 w-auto dark:hidden"
              />
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src="/images/brand/logo-plenos-blanco-optimized.png"
                alt="Rizoma"
                className="h-7 w-auto hidden dark:block"
              />
            </a>
            <div className="flex gap-6 text-sm text-gray-500 dark:text-gray-400">
              <Link href="https://rizo.ma" className="hover:text-rizoma-green transition-colors">
                rizo.ma
              </Link>
              <Link href="https://rizo.ma/contacto" className="hover:text-rizoma-green transition-colors">
                Contacto
              </Link>
              <Link href="https://rizo.ma/politicas" className="hover:text-rizoma-green transition-colors">
                Políticas
              </Link>
            </div>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              © {new Date().getFullYear()} Rizoma. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </footer>
    </div>
  )
}
