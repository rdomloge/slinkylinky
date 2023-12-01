
import { useSession, signIn, signOut } from "next-auth/react";
import Image from "next/image";

export default function Profile() {
    const { data: session } = useSession();

    
        if(session) {
            return(
                <div className="flex p-2">
                    <div className="flex-1 p-1 h-1">
                        <h4 className="text-right">Signed in as {session.user.name}</h4>
                        <button className="float-right" onClick={() => signOut()}>Sign out</button>
                    </div>
                    <Image className="rounded-full p-1 flex-none border-2 border-blue-600" src={session.user.image} alt="Profile image" width={60} height={60}/>
                </div>
            );
        }
        else {
            return (
                <span className="inline-block p-2">
                <button className="float-right" onClick={() => signIn()}>Log in</button>
                </span>
            );
        }    
}