export default function Modal({children, dismissHandler, title, width, id = "default-modal"}) {
    return (
        <>
            <div id={id} tabIndex="-1" aria-hidden="true" 
                    className="bg-gray-500/50 overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full">
                <div className=
                        "justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
                    <div className={"card relative my-6 mx-auto "+(width?width:"w-auto")}>
                        <div className="flex mb-12">
                            {title ?
                            <div className="bg-gray-700 absolute top-0 right-0 left-0 rounded-t-lg p-2 flex-1">
                                <p className="text-white text-left pl-2">{title}</p>
                            </div>
                            : null}
                            <button onClick={dismissHandler} className="contents absolute">
                                <p className="absolute text-red-500 text font-bold text-3xl text-right pr-3 inherit top-0 right-0">X</p>
                            </button>
                        </div>
                        {children}
                    </div>
                </div>
            </div>
        </>
    );
}