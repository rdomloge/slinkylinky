import LockedImage from '@/assets/locked.svg';

const colorMap = {
    blue:  { active: 'bg-blue-600 text-white',   idle: 'bg-blue-50 text-blue-700 hover:bg-blue-100' },
    amber: { active: 'bg-amber-500 text-white',  idle: 'bg-amber-50 text-amber-700 hover:bg-amber-100' },
};

export default function NumberInput({label, disabled, binding, changeHandler, id, step = 1, min = 0, max = 1000000, options, color = 'blue'}) {
    if (options) {
        const scheme = colorMap[color] ?? colorMap.blue;
        return (
            <div className="flex flex-col gap-1">
                <span className="text-xs font-semibold text-gray-500 uppercase tracking-wide flex items-center gap-1.5">
                    {label}
                    {disabled && <img src={LockedImage} width={12} alt="locked" className="opacity-40"/>}
                </span>
                <div className="flex gap-2 flex-wrap">
                    {options.map(opt => (
                        <button key={opt} type="button"
                            onClick={() => changeHandler(opt)}
                            disabled={disabled}
                            className={`px-3 py-1.5 rounded-full text-sm font-medium transition-colors
                                ${disabled
                                    ? 'opacity-40 cursor-not-allowed bg-gray-100 text-gray-400'
                                    : binding == opt ? scheme.active : scheme.idle}`}
                        >
                            {opt}
                        </button>
                    ))}
                </div>
            </div>
        );
    }

    return (
        <div className="flex flex-col gap-1">
            <label className="text-xs font-semibold text-gray-500 uppercase tracking-wide flex items-center gap-1.5" htmlFor={id}>
                {label}
                {disabled && <img src={LockedImage} width={12} alt="locked" className="opacity-40"/>}
            </label>
            <input
                id={id}
                type="number"
                value={binding ?? ''}
                onChange={e => changeHandler(e.target.value)}
                disabled={disabled}
                step={step}
                min={min}
                max={max}
                className={`w-full rounded-lg border px-3 py-2 text-sm text-gray-800
                    focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors
                    ${disabled
                        ? 'bg-gray-50 border-gray-200 text-gray-400 cursor-not-allowed'
                        : 'bg-white border-gray-200 hover:border-gray-300'
                    }`}
            />
        </div>
    );
}
