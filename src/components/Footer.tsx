'use client';

import { useEffect, useRef } from 'react';

const BASE = 'https://www.rizo.ma';

const footerLinks = {
  servicios: [
    { name: 'Gestión de Procesos', href: `${BASE}/gestion-de-procesos` },
    { name: 'Gestión de Proyectos', href: `${BASE}/gestion-de-proyectos` },
    { name: 'Capacitación', href: `${BASE}/capacitacion-corporativa` },
  ],
  productos: [
    { name: 'Team Boost', href: `${BASE}/productos/sprint-operacional` },
    { name: 'MRI Organizacional', href: `${BASE}/productos/mri-organizacional` },
  ],
  nosotros: [
    { name: 'Manifiesto', href: `${BASE}/manifiesto` },
    { name: 'Impacto', href: `${BASE}/impacto` },
    { name: 'Tecnología', href: `${BASE}/tecnologia` },
    { name: 'Equipo', href: `${BASE}/equipo` },
  ],
  recursos: [
    { name: 'Recursos', href: `${BASE}/recursos` },
    { name: 'Blog', href: `${BASE}/blog` },
  ],
  legal: [
    { name: 'Términos y Condiciones', href: `${BASE}/terminos` },
    { name: 'Política de Privacidad', href: `${BASE}/privacidad` },
    { name: 'Políticas Empresariales', href: `${BASE}/politicas` },
  ],
};

export default function Footer() {
  const newsletterRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    let loaded = false;
    const el = newsletterRef.current?.querySelector('[data-tally-open]');
    if (!el) return;

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !loaded) {
          loaded = true;
          const script = document.createElement('script');
          script.src = 'https://tally.so/widgets/embed.js';
          script.async = true;
          document.body.appendChild(script);
          observer.disconnect();
        }
      },
      { rootMargin: '200px' }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-gray-900 text-gray-300">
      {/* Newsletter Section */}
      <div className="border-b border-gray-800" ref={newsletterRef}>
        <div className="max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <div className="flex flex-col lg:flex-row items-center justify-between gap-6">
            <div>
              <h3 className="text-white text-xl font-serif font-semibold">
                Suscríbete a nuestro newsletter
              </h3>
              <p className="text-gray-300 mt-1">
                Recibe insights sobre transformación organizacional y cultura digital.
              </p>
            </div>
            <button
              data-tally-open="68jekY"
              data-tally-width="400"
              data-tally-emoji-animation="wave"
              className="whitespace-nowrap inline-flex items-center gap-2 px-6 py-3 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark transition-colors font-medium shadow-button"
            >
              {/* Envelope icon */}
              <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 256 256">
                <path d="M224,48H32a8,8,0,0,0-8,8V192a16,16,0,0,0,16,16H216a16,16,0,0,0,16-16V56A8,8,0,0,0,224,48ZM203.43,64,128,133.15,52.57,64ZM216,192H40V74.19l82.59,75.71a8,8,0,0,0,10.82,0L216,74.19V192Z" />
              </svg>
              Suscribirme
            </button>
          </div>
        </div>
      </div>

      {/* Main Footer */}
      <div className="max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-8 lg:gap-10">
          {/* Brand */}
          <div className="col-span-2 md:col-span-1">
            <a href={BASE} className="inline-block">
              <picture>
                <source srcSet="/images/brand/logo-plenos-blanco-optimized.webp" type="image/webp" />
                <img
                  src="/images/brand/logo-plenos-blanco-optimized.png"
                  alt="Rizoma"
                  width={83}
                  height={40}
                  className="h-10 w-auto"
                />
              </picture>
            </a>
            <p className="mt-4 text-gray-300 text-sm leading-relaxed">
              Aceleramos la evolución cultural y digital de tu empresa
            </p>
            {/* Social Links */}
            <div className="flex gap-4 mt-6">
              <a
                href="https://linkedin.com/company/somosrizoma"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-lg bg-gray-800 hover:bg-rizoma-green flex items-center justify-center transition-colors"
                aria-label="LinkedIn"
              >
                {/* LinkedIn icon */}
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 256 256">
                  <path d="M216,24H40A16,16,0,0,0,24,40V216a16,16,0,0,0,16,16H216a16,16,0,0,0,16-16V40A16,16,0,0,0,216,24ZM96,176a8,8,0,0,1-16,0V112a8,8,0,0,1,16,0ZM88,96a12,12,0,1,1,12-12A12,12,0,0,1,88,96Zm96,80a8,8,0,0,1-16,0V140a20,20,0,0,0-40,0v36a8,8,0,0,1-16,0V112a8,8,0,0,1,15.79-1.78A36,36,0,0,1,184,140Z" />
                </svg>
              </a>
            </div>

            {/* BNI Membership */}
            <div className="mt-6 pt-6 border-t border-gray-800">
              <div className="flex items-center gap-3">
                <span className="text-gray-300 text-sm">Miembro de</span>
                <a
                  href="https://www.bni.com/country/panama/"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center hover:opacity-80 transition-opacity"
                  title="BNI Capítulo Lovebrand - Panamá"
                >
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src="/images/partners/bni-logo.svg"
                    alt="BNI"
                    width={70}
                    height={28}
                    className="h-7 w-auto"
                  />
                </a>
              </div>
              <p className="text-gray-300 text-xs mt-1">Capítulo Lovebrand</p>
            </div>
          </div>

          {/* Servicios */}
          <div>
            <h4 className="text-white font-serif font-semibold mb-4">Servicios</h4>
            <ul className="space-y-3">
              {footerLinks.servicios.map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-gray-300 hover:text-white transition-colors text-sm">
                    {link.name}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Productos */}
          <div>
            <h4 className="text-white font-serif font-semibold mb-4">Productos</h4>
            <ul className="space-y-3">
              {footerLinks.productos.map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-gray-300 hover:text-white transition-colors text-sm">
                    {link.name}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Nosotros */}
          <div>
            <h4 className="text-white font-serif font-semibold mb-4">Nosotros</h4>
            <ul className="space-y-3">
              {footerLinks.nosotros.map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-gray-300 hover:text-white transition-colors text-sm">
                    {link.name}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Recursos */}
          <div>
            <h4 className="text-white font-serif font-semibold mb-4">Recursos</h4>
            <ul className="space-y-3">
              {footerLinks.recursos.map((link) => (
                <li key={link.href}>
                  <a href={link.href} className="text-gray-300 hover:text-white transition-colors text-sm">
                    {link.name}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Contacto */}
          <div>
            <h4 className="text-white font-serif font-semibold mb-4">Contacto</h4>
            <ul className="space-y-3 text-sm">
              <li>
                <a href="mailto:ulises@rizo.ma" className="text-gray-300 hover:text-white transition-colors">
                  ulises@rizo.ma
                </a>
              </li>
              <li>
                <a
                  href={`${BASE}/agendar`}
                  className="inline-flex items-center gap-2 text-emerald-400 hover:text-white transition-colors"
                >
                  {/* Calendar icon */}
                  <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 256 256">
                    <path d="M208,32H184V24a8,8,0,0,0-16,0v8H88V24a8,8,0,0,0-16,0v8H48A16,16,0,0,0,32,48V208a16,16,0,0,0,16,16H208a16,16,0,0,0,16-16V48A16,16,0,0,0,208,32ZM48,48H72v8a8,8,0,0,0,16,0V48h80v8a8,8,0,0,0,16,0V48h24V80H48ZM208,208H48V96H208V208Z" />
                  </svg>
                  Agendar reunión
                </a>
              </li>
              <li>
                <a
                  href={`${BASE}/carreras`}
                  className="inline-flex items-center gap-2 text-rizoma-cyan hover:text-white transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  Aplica ahora
                </a>
              </li>
              <li>
                <a
                  href={`${BASE}/pagos`}
                  className="inline-flex items-center gap-2 text-gray-300 hover:text-white transition-colors"
                >
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
                  </svg>
                  Formas de pago
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>

      {/* Bottom Bar */}
      <div className="border-t border-gray-800">
        <div className="max-w-[1280px] mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4 text-sm">
            <p className="text-gray-300">&copy; {currentYear} Rizoma. Todos los derechos reservados.</p>
            <div className="flex gap-6">
              {footerLinks.legal.map((link) => (
                <a key={link.href} href={link.href} className="text-gray-300 hover:text-white transition-colors">
                  {link.name}
                </a>
              ))}
              <a
                href={`${BASE}/portal`}
                rel="nofollow"
                className="text-gray-300 hover:text-rizoma-cyan transition-colors"
                title="Portal de Colaboradores"
              >
                Portal
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
