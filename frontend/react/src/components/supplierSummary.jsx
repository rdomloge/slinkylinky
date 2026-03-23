import DaIcon from '@/assets/authority.svg';
import MoneyIcon from '@/assets/tag.svg';

export default function SupplierSummary({supplier}) {
    if (!supplier) return <span className="text-xs text-gray-400">Loading...</span>;

    if (supplier.thirdParty) {
        return (
            <span className="text-base font-semibold text-gray-900">{supplier.name}</span>
        );
    }

    return (
        <div className="flex items-center flex-wrap gap-2 min-w-0">
            <span className="text-base font-semibold text-gray-900 truncate">{supplier.domain}</span>
            <span className="inline-flex items-center gap-1 bg-blue-50 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">
                <img src={DaIcon} alt="DA" width={11} height={11}/>
                DA {supplier.da}
            </span>
            {supplier.weWriteFee &&
                <span className="inline-flex items-center gap-1 bg-gray-100 text-gray-600 text-xs font-medium px-2.5 py-1 rounded-full">
                    <img src={MoneyIcon} alt="fee" width={11} height={11}/>
                    {supplier.weWriteFeeCurrency}{supplier.weWriteFee}
                </span>
            }
        </div>
    );
}
