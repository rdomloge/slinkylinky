
import { useAuth } from "@/auth/AuthProvider";
import Icon from "@/assets/user.svg";

export default function Profile() {
    const { user, signIn, signOut } = useAuth();

    return (
        <>
            {user ?
                <div className="flex items-center gap-3">
                    <div className="text-right">
                        <div className="text-sm font-medium text-slate-700 leading-tight">Signed in as {user.name}</div>
                        <button
                            className="text-xs text-slate-400 hover:text-slate-600 transition-colors"
                            onClick={() => signOut()}
                        >
                            Sign out
                        </button>
                    </div>
                    {user.image ?
                        <img className="rounded-full border-2 border-slate-200 h-9 w-9 object-cover" src={user.image} alt="Profile image"/>
                    :
                        <img className="rounded-full border-2 border-slate-200 h-9 w-9" src={Icon} alt="Profile image"/>
                    }
                </div>
            :
                <div className="flex items-center gap-3">
                    <button
                        className="text-sm text-indigo-600 hover:text-indigo-800 font-medium transition-colors"
                        onClick={() => signIn()}
                    >
                        Sign in for privileged access
                    </button>
                    <img className="rounded-full border-2 border-slate-200 h-9 w-9" src={Icon} alt="Profile image"/>
                </div>
            }
        </>
    );
}
