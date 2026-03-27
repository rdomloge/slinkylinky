import Profile from '../Profile';

export default function Header() {
    return (
        <header className="bg-white border-b border-slate-200 sticky top-0 z-30 shadow-sm">
            <div className="flex items-center justify-end px-6 py-2">
                <Profile/>
            </div>
        </header>
    );
}
