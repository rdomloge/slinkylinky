import { useSession } from "next-auth/react";

export default function DemandHeadline({demand}) {
    const { data: session } = useSession();

    return (
        <>
            {session ?
                <p className={"text-right " +(demand.createdBy===session.user.email?"text-red-700 font-bold":"")}>
                    {demand.name} (DA {demand.daNeeded})
                </p>
            :
                <p className="text-right">
                    {demand.name} (DA {demand.daNeeded})
                </p>
            }
        </>
    );
}