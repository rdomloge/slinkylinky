import { useSession } from "next-auth/react";

export default function DemandHeadline({linkDemand}) {
    const { data: session } = useSession();

    return (
        <>
            {session ?
                <p className={"text-right " +(linkDemand.createdBy===session.user.email?"text-red-700 font-bold":"")}>
                    {linkDemand.name} (DA {linkDemand.daNeeded})
                </p>
            :
                <p className="text-right">
                    {linkDemand.name} (DA {linkDemand.daNeeded})
                </p>
            }
        </>
    );
}