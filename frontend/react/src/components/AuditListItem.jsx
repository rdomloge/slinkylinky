import { Link } from "react-router-dom";
import { NiceDateTime } from "./atoms/DateTime";

export default function AuditListItem({ auditrecord }) {
    return (
        <Link
            to={`/audit/trace?entityType=${auditrecord.entityType}&entityId=${auditrecord.entityId}`}
            rel="nofollow"
            className="block"
        >
            <div className="card list-card hover:bg-slate-50 transition-colors p-2">
                <div className="grid grid-cols-4 gap-4 items-center text-sm">
                    <div>
                        <p className="text-slate-400">
                            <NiceDateTime isostring={auditrecord.eventTime} />
                        </p>
                    </div>
                    <div>
                        <p className="text-slate-600 font-medium truncate">
                            {auditrecord.who}
                        </p>
                    </div>
                    <div>
                        <p className="text-slate-700 capitalize font-medium truncate">
                            {auditrecord.what}
                        </p>
                    </div>
                    <div>
                        <div className="flex items-center gap-2">
                            <p className="font-mono text-indigo-600 font-medium">
                                {auditrecord.entityId}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </Link>
    );
}
