import { useAuth } from "@/auth/AuthProvider";

export default function DemandHeadline({demand}) {
    const { user } = useAuth();

    return (
        <>
            {user ?
                <p className={"text-right " +(demand.createdBy===user.email?"text-red-700 font-bold":"")}>
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