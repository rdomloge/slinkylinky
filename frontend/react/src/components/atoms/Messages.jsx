function Message({ message, id, icon, colorClasses }) {
    if (!message) return null;
    return (
        <div className={`flex items-start gap-3 px-4 py-3 rounded-lg border-l-4 ${colorClasses.wrap}`} id={id}>
            <span className={`shrink-0 mt-0.5 ${colorClasses.icon}`}>{icon}</span>
            <p className={`text-sm leading-snug ${colorClasses.text}`}>{message}</p>
        </div>
    );
}

const icons = {
    warning: (
        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
        </svg>
    ),
    info: (
        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="m11.25 11.25.041-.02a.75.75 0 0 1 1.063.852l-.708 2.836a.75.75 0 0 0 1.063.853l.041-.021M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9-3.75h.008v.008H12V8.25Z" />
        </svg>
    ),
    error: (
        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
        </svg>
    ),
    success: (
        <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
        </svg>
    ),
};

export default function ErrorMessage({ message, id }) {
    return <Message message={message} id={id} icon={icons.error}
        colorClasses={{ wrap: 'bg-red-50 border-red-400', icon: 'text-red-500', text: 'text-red-800' }}/>;
}

export function WarningMessage({ message, id }) {
    return <Message message={message} id={id} icon={icons.warning}
        colorClasses={{ wrap: 'bg-amber-50 border-amber-400', icon: 'text-amber-500', text: 'text-amber-800' }}/>;
}

export function InfoMessage({ message, id }) {
    return <Message message={message} id={id} icon={icons.info}
        colorClasses={{ wrap: 'bg-blue-50 border-blue-400', icon: 'text-blue-500', text: 'text-blue-800' }}/>;
}

export function SuccessMessage({ message, id }) {
    return <Message message={message} id={id} icon={icons.success}
        colorClasses={{ wrap: 'bg-emerald-50 border-emerald-400', icon: 'text-emerald-500', text: 'text-emerald-800' }}/>;
}
