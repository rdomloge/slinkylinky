
import { useAuth } from "@/auth/AuthProvider";
import Icon from "@/components/user.svg";

export default function Profile() {
    const { user, signIn, signOut } = useAuth();
    
            return(
                <>
                    {user ?
                        <div className="flex p-2">
                            <div className="flex-1 p-1 h-1">
                                <h4 className="text-right">Signed in as {user.name}</h4>
                                <button className="float-right" onClick={() => signOut()}>Sign out</button>
                            </div>
                            {user.image ?
                                <img className="rounded-full p-1 flex-none border-2 border-blue-600" src={user.image} alt="Profile image" width={60} height={60}/>
                            :
                                <img className="rounded-full p-1 flex-none border-2 border-blue-600" src={Icon} alt="Profile image" width={60} height={60}/>
                            }
                        </div>
                    :
                        <div className="flex p-2">
                            <div className="flex-1 p-1 h-1">
                                <h4 className="text-right">Sign in for privileged access</h4>
                                <button className="float-right" onClick={() => signIn()}>Sign in</button>
                            </div>
                            <img className="rounded-full p-1 flex-none border-2 border-blue-600" src={Icon} alt="Profile image" width={60} height={60}/>
                        </div>
                    }
                </>
            );
}