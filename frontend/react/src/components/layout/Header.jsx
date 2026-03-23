import Icon from '@/assets/logo.png'
import Profile from '../Profile';

export default function Header() {
    return (
        <nav className="bg-white sticky top-0 z-30">
            <div className="flex items-center justify-between px-6 py-3">
                <a href="/" className="flex items-center gap-3">
                    <img src={Icon} width={439/8} height={498/8} alt="Logo"/>
                    <span className="text-xl font-bold text-gray-900 tracking-tight">Slinky Linky</span>
                </a>
                <Profile/>
            </div>
        </nav>
    );
}
