import { useSession } from "next-auth/react";

export default function SessionButton({label, clickHandler}) {
    
    const { data: session } = useSession();

    return (
        <button disabled={!session} onClick={clickHandler}
            className={"text-white font-bold py-2 px-4 border border-blue-700 rounded "
                +(session ? "bg-blue-500 hover:bg-blue-700" : "bg-grey-500 hover:bg-grey-700")}>
            {label}
        </button>
    );
}

export function EditDemandSubmitButton({submitHandler, demand, demandsite}) {

    const baseClass = "text-white font-bold py-2 p-4 border border-blue-700 rounded "
    const enabledClass = baseClass + "bg-blue-500 hover:bg-blue-700"
    const disabledClass = baseClass + "bg-grey-500 hover:bg-grey-700"

    return (
        <button id="createnew" onClick={submitHandler} disabled={!demand.id ? !demandsite : false}
            className={!demand.id ? (demandsite ? enabledClass : disabledClass) : enabledClass}>
            Submit
        </button>
    );
}

export function SessionBlock({children}) {
    const { data: session } = useSession();
    
    return (
        <div className={session ? "visible" : "invisible"}>
            {children}
        </div>
    );
}

export function ClickHandlerButton({label, clickHandler, disabled}) {
    return (
        <button className={"text-white font-bold py-2 px-4 border border-blue-700 rounded "
                            +(disabled ? "bg-grey-500 hover:bg-grey-700" : "bg-blue-500 hover:bg-blue-700")}
                disabled={disabled} onClick={clickHandler ? clickHandler : ()=>{}}>
            {label}
        </button>
    );
}