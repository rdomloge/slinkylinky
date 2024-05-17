import { useSession } from "next-auth/react";

export default function SessionButton({label, clickHandler}) {
    
    const { data: session } = useSession();

    return (
        <button disabled={!session} onClick={clickHandler}
            className={"text-slate-200 font-bold py-2 px-4 border border-blue-700 rounded align-super "
                +(session ? "bg-blue-500 hover:bg-blue-700" : "bg-grey-500 hover:bg-grey-700")}>
            {label}
        </button>
    );
}

export function EditDemandSubmitButton({submitHandler, demand, demandsite}) {

    const baseClass = "text-slate-200 font-bold py-2 p-4 border border-blue-700 rounded inline-block "
    const enabledClass = baseClass + "bg-blue-500 hover:bg-blue-700"
    const disabledClass = baseClass + "bg-grey-500 hover:bg-grey-700"

    return (
        <button id="createnew" onClick={submitHandler} disabled={!demand.id ? !demandsite : false}
            className={!demand.id ? (demandsite ? enabledClass : disabledClass) : enabledClass}>
            Submit
        </button>
    );
}

export function StyledButton({submitHandler, enabled = true, label = "Submit", type = "primary", isText = false, extraClass = "", id = ""}) {
    const baseClass = "m-2 text-white font-bold py-2 px-4 border rounded disabled:opacity-50 "
    const buttonTypes = {
        primary: "bg-blue-700 hover:bg-blue-900 border-blue-900",
        secondary: "bg-green-700 hover:bg-green-900 border-green-900",
        tertiary: "bg-indigo-700 hover:bg-indigo-900 border-indigo-900",
        risky: "bg-red-700 hover:bg-red-900 border-red-900"
    }
    const textTypes = {
        primary: "text-blue-700 hover:text-blue-900",
        secondary: "text-green-700 hover:text-green-900",
        tertiary: "text-indigo-700 hover:text-indigo-900",
        risky: "text-red-700 hover:text-red-500",
    }

    const buttonClass = `${baseClass} ${buttonTypes[type]} ${enabled ? '' : ' opacity-50 cursor-not-allowed'}`;
    const textClass = `${textTypes[type]} ${enabled ? ' cursor-pointer' : ' opacity-50 cursor-not-allowed'}`;

    if (isText) {
        return (
            <span id={id} onClick={submitHandler} className={textClass+" "+extraClass}>
                {label}
            </span>
        );
    } else {
        return (
            <button id={id} onClick={submitHandler} disabled={!enabled} className={buttonClass+" "+extraClass}>
                {label}
            </button>
        );
    }
}

export function SessionBlock({children}) {
    const { data: session } = useSession();
    
    return (<section className={session ? "visible" : "invisible"}>{children}</section>);
}

export function ClickHandlerButton({label, clickHandler, disabled, id}) {
    return (
        <button className={"text-slate-200 font-bold py-2 px-4 border border-blue-700 rounded "
                            +(disabled ? "bg-grey-500 hover:bg-grey-700" : "bg-blue-500 hover:bg-blue-700")}
                disabled={disabled} onClick={clickHandler ? clickHandler : ()=>{}} id={id}>
            {label}
        </button>
    );
}