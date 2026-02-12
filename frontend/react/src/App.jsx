import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from '@/auth/AuthProvider';
import ReactGA from 'react-ga4';

import Callback from '@/auth/Callback';

import AuditIndex from '@/pages/audit/index';
import AuditTrace from '@/pages/audit/trace';
import DemandIndex from '@/pages/demand/index';
import DemandDetail from '@/pages/demand/[demandid]';
import DemandAdd from '@/pages/demand/Add';
import DemandSitesIndex from '@/pages/demandsites/index';
import DemandSiteDetail from '@/pages/demandsites/[demandsiteid]';
import DemandSiteHistory from '@/pages/demandsites/history';
import SupplierIndex from '@/pages/supplier/index';
import SupplierDetail from '@/pages/supplier/[supplierid]';
import SupplierAdd from '@/pages/supplier/Add';
import SupplierList2 from '@/pages/supplier/index2';
import SupplierSearch from '@/pages/supplier/search/[demandid]';
import ProposalsIndex from '@/pages/proposals/index';
import ProposalDetail from '@/pages/proposals/[proposalid]';
import OrdersIndex from '@/pages/orders/index';
import CategoriesIndex from '@/pages/categories/index';
import SupplierResponse from '@/pages/public/supplierresponse/index';
import PaidLinksStaging from '@/pages/paidlinks/staging';
import Sandbox from '@/pages/sandbox/index';

const TRACKING_ID = import.meta.env.VITE_GA_TRACKING_ID || "G-4K0WX1L508";
ReactGA.initialize(TRACKING_ID);

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Public routes */}
          <Route path="/callback" element={<Callback />} />
          <Route path="/public/supplierresponse" element={<SupplierResponse />} />

          {/* Protected routes */}
          <Route path="/" element={<Navigate to="/demand" replace />} />
          <Route path="/demand" element={<DemandIndex />} />
          <Route path="/demand/add" element={<DemandAdd />} />
          <Route path="/demand/:demandid" element={<DemandDetail />} />
          <Route path="/demandsites" element={<DemandSitesIndex />} />
          <Route path="/demandsites/history" element={<DemandSiteHistory />} />
          <Route path="/demandsites/:demandsiteid" element={<DemandSiteDetail />} />
          <Route path="/supplier" element={<SupplierIndex />} />
          <Route path="/supplier/add" element={<SupplierAdd />} />
          <Route path="/supplier/list2" element={<SupplierList2 />} />
          <Route path="/supplier/search/:demandid" element={<SupplierSearch />} />
          <Route path="/supplier/:supplierid" element={<SupplierDetail />} />
          <Route path="/proposals" element={<ProposalsIndex />} />
          <Route path="/proposals/:proposalid" element={<ProposalDetail />} />
          <Route path="/orders" element={<OrdersIndex />} />
          <Route path="/audit" element={<AuditIndex />} />
          <Route path="/audit/trace" element={<AuditTrace />} />
          <Route path="/categories" element={<CategoriesIndex />} />
          <Route path="/paidlinks/staging" element={<PaidLinksStaging />} />
          <Route path="/sandbox" element={<Sandbox />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
