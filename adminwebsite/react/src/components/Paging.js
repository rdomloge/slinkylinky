import Router from 'next/router';

export default function Paging({ total, page, pageCount, baseUrl, baseQuery = {} }) {
    
    const pages = Array.from({ length: pageCount }, (_, i) => i + 1);

    const getPageNumbers = () => {
        if (pageCount <= 5) {
            return pages;
        }

        const pageNumbers = buildPageNumbers();

        const uniquePageNumbers = Array.from(new Set(pageNumbers)).sort((a, b) => a - b);

        if (uniquePageNumbers[0] !== 1) {
            uniquePageNumbers.unshift("...");
            uniquePageNumbers.unshift(1);
        }

        if (uniquePageNumbers[uniquePageNumbers.length - 1] !== pageCount) {
            uniquePageNumbers.push("...");
            uniquePageNumbers.push(pageCount);
        }

        return uniquePageNumbers;
    };

    function buildPageNumbers() {
        const pageNumbers = [];
        
        const rangeStart = Math.min(pageCount - 4, Math.max(1, page - 2));
        const rangeEnd = Math.min(pageCount, Math.max(page + 2 , rangeStart + 4));

        for (let i = rangeStart; i <= rangeEnd; i++) {
            pageNumbers.push(i);
        }


        return pageNumbers;
    }

    function setUrl(path, xtraquery) {
        let query = {...baseQuery, ...xtraquery}
        Router.push({
            pathname: path,
            query: query
          }, 
          undefined, { shallow: true }
          ) 
    }

    return (
        <nav className="flex justify-center my-4">
            <button
                onClick={() => setUrl(baseUrl, {"page":  page - 1})}
                className={`px-3 py-2 mx-1 rounded-md ${page === 1 ? 'cursor-not-allowed opacity-50' : 'hover:bg-blue-500 hover:text-white'}`}
                disabled={page === 1}
            >
                Previous
            </button>
            {getPageNumbers().map((pageNumber,index) => (
                pageNumber === "..." ?
                    <span className="px-3 py-2 mx-1 rounded-md" key={index}>...</span>
                :
                <button
                    key={index}
                    onClick={() => setUrl(baseUrl, {"page": pageNumber})}
                    className={`px-3 py-2 mx-1 rounded-md ${pageNumber === page ? 'bg-blue-500 text-white' : 'hover:bg-blue-500 hover:text-white'}`}
                >
                    {pageNumber}
                </button>
            ))}
            <button
                onClick={() => setUrl(baseUrl, {"page": page + 1})}
                className={`px-3 py-2 mx-1 rounded-md ${page === pageCount ? 'cursor-not-allowed opacity-50' : 'hover:bg-blue-500 hover:text-white'}`}
                disabled={page === pageCount}
            >
                Next
            </button>
        </nav>
    );
}