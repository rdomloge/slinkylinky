import Icon from '@/assets/logo.png'

export default function Footer() {
    return (
        <footer className="m-4 mt-8">
            <div className="w-full max-w-screen-xl mx-auto px-4 py-6 border-t border-slate-200">
                <div className="sm:flex sm:items-center sm:justify-between">
                    <a href="/" className="flex items-center mb-4 sm:mb-0 gap-2">
                        <img src={Icon} width={Math.round(439/8)} height={Math.round(498/8)} alt="Logo" className="p-1 opacity-40 inline-block"/>
                        <span className="text-sm font-semibold text-slate-400 whitespace-nowrap">Slinky Linky</span>
                    </a>
                    <ul className="flex flex-wrap items-center gap-4 text-xs font-medium text-slate-400">
                        <li><a href="#" className="hover:text-slate-600 transition-colors">About</a></li>
                        <li><a href="#" className="hover:text-slate-600 transition-colors">Privacy Policy</a></li>
                        <li><a href="#" className="hover:text-slate-600 transition-colors">Licensing</a></li>
                        <li><a href="#" className="hover:text-slate-600 transition-colors">Contact</a></li>
                    </ul>
                </div>
                <p className="mt-4 text-xs text-slate-400 sm:text-center">
                    © 2023 <a href="/" className="hover:underline">Slinky Linky™</a>. All Rights Reserved.
                </p>
            </div>
        </footer>
    );
}
