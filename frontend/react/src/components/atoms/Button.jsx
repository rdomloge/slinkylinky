import { useAuth } from "@/auth/AuthProvider";

export default function SessionButton({label, clickHandler}) {

    const { isAuthenticated } = useAuth();

    return (
        <button disabled={!isAuthenticated} onClick={clickHandler}
            className={"text-white font-semibold py-2 px-4 rounded-lg border transition-colors "
                +(isAuthenticated
                    ? "bg-indigo-600 hover:bg-indigo-700 border-indigo-700"
                    : "bg-slate-300 border-slate-400 cursor-not-allowed opacity-60")}>
            {label}
        </button>
    );
}

export function StyledButton({submitHandler, enabled = true, label = "Submit", type = "primary", isText = false, extraClass = "", id = ""}) {
    const baseClass = "m-2 text-white font-semibold py-2 px-4 rounded-lg border disabled:opacity-50 transition-colors "
    const buttonTypes = {
        primary:   "bg-indigo-600 hover:bg-indigo-700 border-indigo-700",
        secondary: "bg-emerald-600 hover:bg-emerald-700 border-emerald-700",
        tertiary:  "bg-violet-600 hover:bg-violet-700 border-violet-700",
        risky:     "bg-red-600 hover:bg-red-700 border-red-700"
    }
    const textTypes = {
        primary:   "text-indigo-600 hover:text-indigo-800 transition-colors",
        secondary: "text-emerald-600 hover:text-emerald-800 transition-colors",
        tertiary:  "text-violet-600 hover:text-violet-800 transition-colors",
        risky:     "text-red-500 hover:text-red-700 transition-colors",
    }

    const buttonClass = `${baseClass} ${buttonTypes[type]} ${enabled ? '' : ' opacity-50 cursor-not-allowed'}`;
    const textClass = `text-xs font-medium ${textTypes[type]} ${enabled ? ' cursor-pointer' : ' opacity-50 cursor-not-allowed'}`;

    if (isText) {
        return (
            <span id={id} onClick={enabled ? submitHandler : undefined}
                  role="button" tabIndex={enabled ? 0 : -1}
                  className={textClass+" "+extraClass}>
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
    const { isAuthenticated } = useAuth();

    return (<section className={isAuthenticated ? "visible" : "invisible"}>{children}</section>);
}

export function ClickHandlerButton({label, clickHandler, disabled, id}) {
    return (
        <button className={"text-white font-semibold py-2 px-4 rounded-lg border transition-colors "
                            +(disabled
                                ? "bg-slate-300 border-slate-400 cursor-not-allowed opacity-60"
                                : "bg-indigo-600 hover:bg-indigo-700 border-indigo-700")}
                disabled={disabled} onClick={clickHandler ? clickHandler : ()=>{}} id={id}>
            {label}
        </button>
    );
}
