import Icon from '@/assets/robot-error.svg'

export default function Loading({ error }) {
    if (error) {
        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 backdrop-blur-sm">
                <div className="flex flex-col items-center gap-4 rounded-2xl bg-white px-10 py-8 shadow-xl border border-gray-200 max-w-sm text-center">
                    <img src={Icon} width={72} height={72} alt="Error icon" />
                    <div>
                        <p className="text-base font-semibold text-gray-700">Something went wrong</p>
                        <p className="mt-1 text-sm text-red-500">
                            {typeof error === 'string' || error instanceof String ? error : error.message}
                        </p>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
            <div className="flex items-center gap-2" role="status" aria-label="Loading">
                <span className="block h-3 w-3 rounded-full bg-blue-600 animate-bounce [animation-delay:-0.3s]" />
                <span className="block h-3 w-3 rounded-full bg-blue-600 animate-bounce [animation-delay:-0.15s]" />
                <span className="block h-3 w-3 rounded-full bg-blue-600 animate-bounce" />
            </div>
        </div>
    );
}