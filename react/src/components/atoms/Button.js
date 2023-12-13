import { useSession } from "next-auth/react";

export default function SessionButton({labelText}) {
    
    const { data: session } = useSession();

    return (
        <button disabled={!session}
            className={"text-white font-bold py-2 px-4 border border-blue-700 rounded "
                +(session ? "bg-blue-500 hover:bg-blue-700" : "bg-grey-500 hover:bg-grey-700")}>
            {labelText}
        </button>
    );
}