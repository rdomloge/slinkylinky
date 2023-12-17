export default function Modal({children, dismissHandler, title}) {
    return (
        <>
            <div id="default-modal" tabIndex="-1" aria-hidden="true" className="bg-gray-500/50 overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
            <div className=
                    "justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
                <div className="card relative w-auto my-6 mx-auto max-w-3xl">
                    <div className="flex mb-6">
                        {title ?
                        <div className="bg-gray-700 rounded p-1 m-0 flex-1">
                            <p className="text-white text-center">{title}</p>
                        </div>
                        : null}
                        <button onClick={dismissHandler} className="contents absolute">
                            <p className="text-red-500 text font-bold text-3xl text-right ml-3 pr-1 inherit top-0 right-0">X</p>
                        </button>
                    </div>
                    {children}
                </div>
            </div>
            </div>
        </>
    );
}