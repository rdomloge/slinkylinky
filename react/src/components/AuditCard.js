import Link from "next/link";
import { NiceDateTime } from "./atoms/DateTime";

export default function AuditCard({auditrecord}) {
    return (
        <div className="card">
            <NiceDateTime isostring={auditrecord.eventTime}/>
            <p className="capitalize font-bold">{auditrecord.what}</p>
            <p>{auditrecord.entityType} {auditrecord.entityId}</p>
            <p>{auditrecord.who}</p>
            <p className="break-all">{auditrecord.detail}</p>
        </div>
    );
}

export function AuditLine({auditrecord}) {
    return (
        <>
        <span><NiceDateTime isostring={auditrecord.eventTime}/></span>
        <span>{auditrecord.who} </span>
        <span>{auditrecord.what}</span>
        <Link href={"/audit/trace?entityType="+auditrecord.entityType+"&entityId="+auditrecord.entityId}>
            <span>{auditrecord.entityId}</span>
        </Link>
        </>
    );
}