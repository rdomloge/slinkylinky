import LockedImage from '@/assets/locked.svg';

export default function TextInput({changeHandler, label, binding, disabled, maxLen, id}) {
    return (
        <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-500 uppercase tracking-wide flex items-center gap-1.5" htmlFor={id}>
                {label}
                {disabled && <img src={LockedImage} width={12} alt="locked" className="opacity-40"/>}
            </label>
            <input
                id={id}
                type="text"
                value={binding ?? ''}
                onChange={e => changeHandler(e.target.value)}
                disabled={disabled}
                maxLength={maxLen ?? ''}
                className={`w-full rounded-lg border px-3 py-2 text-sm text-gray-800 placeholder-gray-300
                    focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors
                    ${disabled
                        ? 'bg-gray-50 border-gray-200 text-gray-400 cursor-not-allowed'
                        : 'bg-white border-gray-200 hover:border-gray-300'
                    }`}
            />
        </div>
    );
}
