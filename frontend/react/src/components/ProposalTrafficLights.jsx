import TrafficLight from "./TrafficLight";
import TrafficLightClickHandler from "./TrafficLightClickHandler";

const PROPERTY_DATES = {
    proposalSent:       'dateSentToSupplier',
    proposalAccepted:   'dateAcceptedBySupplier',
    invoiceReceived:    'dateInvoiceReceived',
    invoicePaid:        'dateInvoicePaid',
    blogLive:           'dateBlogLive',
    validated:          'dateValidated',
};

const ALL_STEPS = [
    { prop: 'contentReady',     text: 'Content',      dateKey: null },
    { prop: 'proposalSent',     text: 'Sent',         dateKey: 'dateSentToSupplier' },
    { prop: 'proposalAccepted', text: 'Accepted',     dateKey: 'dateAcceptedBySupplier' },
    { prop: 'invoiceReceived',  text: 'Invoice recv', dateKey: 'dateInvoiceReceived' },
    { prop: 'invoicePaid',      text: 'Invoice paid', dateKey: 'dateInvoicePaid' },
    { prop: 'blogLive',         text: 'Live',         dateKey: 'dateBlogLive' },
    { prop: 'validated',        text: 'Validated',    dateKey: 'dateValidated' },
];

const THIRD_PARTY_PROPS = ['proposalSent', 'blogLive', 'validated'];

export default function TrafficLights({ proposal, updateHandler, interactive, compact = false }) {
    const isThirdParty = proposal.paidLinks[0].supplier.thirdParty;
    const steps = isThirdParty
        ? ALL_STEPS.filter(s => THIRD_PARTY_PROPS.includes(s.prop))
        : ALL_STEPS;

    if (compact) {
        // Compact: single row, small circles, labels below, no dates
        // Line at 18px = 8px padding-top + half of 20px (h-5) circle
        return (
            <div className="relative flex w-full pt-2 pb-1">
                <div className="absolute left-0 right-0 h-px bg-slate-200 z-0" style={{ top: 18 }}/>
                {steps.map((step) => (
                    <div key={step.prop} className="flex-1 flex flex-col items-center">
                        <TrafficLight
                            text={step.text}
                            value={proposal[step.prop]}
                            compact={true}
                        />
                    </div>
                ))}
            </div>
        );
    }

    // Full mode: alternating above/below labels with dates
    // Line at top-28 (112px) = h-20 label + h-4 connector + half of h-8 circle
    return (
        <div className="relative flex w-full">
            <div className="absolute left-0 right-0 h-px bg-slate-200 top-[82px] z-0"/>
            {steps.map((step, i) => {
                const above = i % 2 === 0;
                const light = (
                    <TrafficLight
                        text={step.text}
                        value={proposal[step.prop]}
                        date={step.dateKey ? proposal[step.dateKey] : null}
                        above={above}
                    />
                );

                return (
                    <div key={step.prop} className="flex-1 flex flex-col items-center">
                        {interactive ? (
                            <TrafficLightClickHandler
                                proposal={proposal}
                                updateHandler={updateHandler}
                                propertyName={step.prop}
                                propertyDate={PROPERTY_DATES[step.prop]}
                            >
                                {light}
                            </TrafficLightClickHandler>
                        ) : light}
                    </div>
                );
            })}
        </div>
    );
}
