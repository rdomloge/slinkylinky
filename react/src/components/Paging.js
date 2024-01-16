export default function Paging({ total, page, pageCount, baseUrl }) {

    const pages = Array.from({ length: pageCount }, (_, i) => i + 1);
    console.log("Page: "+page)
    return (
        <nav className="flex justify-center my-4">
            <button
                onClick={() => window.location.href = `${baseUrl}?page=${page - 1}`}
                className={`px-3 py-2 mx-1 rounded-md ${page === 1 ? 'cursor-not-allowed opacity-50' : 'hover:bg-blue-500 hover:text-white'}`}
                disabled={page === 1}
            >
                Previous
            </button>
            {pages.map((pageNumber) => (
                <button
                    key={pageNumber}
                    onClick={() => window.location.href = `${baseUrl}?page=${pageNumber}`}
                    className={`px-3 py-2 mx-1 rounded-md ${pageNumber === page ? 'bg-blue-500 text-white' : 'hover:bg-blue-500 hover:text-white'}`}
                >
                    {pageNumber}
                </button>
            ))}
            <button
                onClick={() => window.location.href = `${baseUrl}?page=${page + 1}`}
                className={`px-3 py-2 mx-1 rounded-md ${page === pageCount ? 'cursor-not-allowed opacity-50' : 'hover:bg-blue-500 hover:text-white'}`}
                disabled={page === pageCount}
            >
                Next
            </button>
        </nav>
    );
}