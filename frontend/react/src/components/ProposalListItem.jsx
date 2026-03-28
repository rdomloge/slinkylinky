import NiceDate from "./atoms/DateTime";
import TrafficLights from "./ProposalTrafficLights";
import SupplierSummary from './SupplierSummary';
import { Link } from 'react-router-dom';
import DemandHeadline from './DemandHeadline';
import CalendarIcon from '@/assets/calendar.svg';
import LinkIcon from '@/assets/link.svg';

export default function ProposalListItem({proposal, originalSupplier = null}) {
    const supplier = originalSupplier ?? proposal.paidLinks[0].supplier;

    return (
        <div className="card list-card">

            {/* Header: supplier info + View link */}
            <div className="flex items-start justify-between gap-2 mb-3">
                <SupplierSummary supplier={supplier}/>
                <Link to={'/proposals/'+proposal.id} rel='nofollow'>
                    <span className="inline-flex items-center px-2.5 py-1 rounded-md bg-indigo-600 text-white text-xs font-semibold hover:bg-indigo-700 transition-colors shrink-0">View</span>
                </Link>
            </div>

            {/* Live link */}
            {proposal.blogLive &&
                <div className="mb-3">
                    <Link to={proposal.liveLinkUrl} rel='nofollow'
                        className="flex items-center gap-2 text-sm text-indigo-600 hover:underline">
                        <img src={LinkIcon} alt="link" width={13} height={13} className="shrink-0 opacity-70"/>
                        <span className="truncate font-medium">{proposal.liveLinkTitle}</span>
                    </Link>
                    <p className="text-xs text-slate-400 mt-0.5 ml-5">
                        Live since <NiceDate isostring={proposal.dateBlogLive}/>
                    </p>
                </div>
            }

            {/* Traffic lights */}
            <TrafficLights proposal={proposal} interactive={false} compact={true}/>

            {/* Footer: date + demands */}
            <div className="flex items-center justify-between gap-3 mt-3 pt-3 border-t border-slate-100">
                <div className="flex items-center gap-1.5 text-xs text-slate-400 shrink-0">
                    <img src={CalendarIcon} alt="calendar" width={12} height={12} className="shrink-0"/>
                    <NiceDate isostring={proposal.dateCreated}/>
                </div>
                <div className="flex flex-wrap gap-1.5 justify-end">
                    {proposal.paidLinks.map((pl, index) =>
                        <DemandHeadline demand={pl.demand} key={index}/>
                    )}
                </div>
            </div>
        </div>
    );
}
