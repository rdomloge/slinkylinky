import { useAuth } from "@/auth/AuthProvider";

export default function DemandHeadline({ demand }) {
    const { user } = useAuth();
    const isOwn = user && demand.createdBy === user.email;

    return (
        <span className={`inline-flex items-center gap-1.5 text-xs px-2.5 py-1 rounded-full border ${
            isOwn
                ? 'bg-amber-50 border-amber-200 text-amber-800'
                : 'bg-slate-50 border-slate-200 text-slate-700'
        }`}>
            <span className="font-medium">{demand.name}</span>
            <span className={`text-[10px] font-semibold px-1.5 py-0.5 rounded-full ${
                isOwn ? 'bg-amber-100 text-amber-700' : 'bg-indigo-100 text-indigo-700'
            }`}>
                DA {demand.daNeeded}
            </span>
        </span>
    );
}
