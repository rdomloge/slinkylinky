import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from '@/auth/AuthProvider';
import { TenantOverrideProvider } from '@/auth/TenantOverrideContext';
import { ToastProvider } from '@/components/atoms/Toasts';
import ReactGA from 'react-ga4';
import { GA_TRACKING_ID } from '@/config';

import Callback from '@/auth/Callback';
import VerifyEmail from '@/pages/verify-email/index';
import Register from '@/pages/register/index';

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
import OrganisationsIndex from '@/pages/organisations/index';
import AdminOrganisationsIndex from '@/pages/admin/organisations/index';
import TenantHealth from '@/pages/admin/health/index';
import UsersIndex from '@/pages/users/index';
import SupplierResponse from '@/pages/public/supplierresponse/index';
import LeadResponse from '@/pages/public/leadresponse/index';
import LeadsIndex from '@/pages/leads/index';
import CategoryMappingsIndex from '@/pages/category-mappings/index';
import PaidLinksStaging from '@/pages/paidlinks/staging';
import Sandbox from '@/pages/sandbox/index';
import DesignPreview from '@/pages/sandbox/design-preview';
import Dashboard from '@/pages/dashboard/index';

ReactGA.initialize(GA_TRACKING_ID);

export default function App() {
  return (
    <AuthProvider>
      <TenantOverrideProvider>
      <ToastProvider>
      <BrowserRouter>
        <Routes>
          {/* Public routes */}
          <Route path="/callback" element={<Callback />} />
          <Route path="/register" element={<Register />} />
          <Route path="/verify-email" element={<VerifyEmail />} />
          <Route path="/public/supplierresponse" element={<SupplierResponse />} />
          <Route path="/public/leadresponse" element={<LeadResponse />} />

          {/* Protected routes */}
          <Route path="/" element={<Dashboard />} />
          <Route path="/demand" element={<DemandIndex />} />
          <Route path="/demand/add" element={<DemandAdd />} />
          <Route path="/demand/:demandid" element={<DemandDetail />} />
          <Route path="/demandsites" element={<DemandSitesIndex />} />
          <Route path="/demandsites/history" element={<DemandSiteHistory />} />
          <Route path="/demandsites/:demandsiteid" element={<DemandSiteDetail />} />
          <Route path="/supplier" element={<SupplierList2 />} />
          <Route path="/supplier/cards" element={<SupplierIndex />} />
          <Route path="/supplier/add" element={<SupplierAdd />} />
          <Route path="/supplier/search/:demandid" element={<SupplierSearch />} />
          <Route path="/supplier/:supplierid" element={<SupplierDetail />} />
          <Route path="/proposals" element={<ProposalsIndex />} />
          <Route path="/proposals/:proposalid" element={<ProposalDetail />} />
          <Route path="/orders" element={<OrdersIndex />} />
          <Route path="/audit" element={<AuditIndex />} />
          <Route path="/audit/trace" element={<AuditTrace />} />
          <Route path="/categories" element={<CategoriesIndex />} />
          <Route path="/organisations" element={<OrganisationsIndex />} />
          <Route path="/admin/organisations" element={<AdminOrganisationsIndex />} />
          <Route path="/admin/health" element={<TenantHealth />} />
          <Route path="/users" element={<UsersIndex />} />
          <Route path="/paidlinks/staging" element={<PaidLinksStaging />} />
          <Route path="/sandbox" element={<Sandbox />} />
          <Route path="/sandbox/design" element={<DesignPreview />} />
          <Route path="/leads" element={<LeadsIndex />} />
          <Route path="/category-mappings" element={<CategoryMappingsIndex />} />
        </Routes>
      </BrowserRouter>
      </ToastProvider>
      </TenantOverrideProvider>
    </AuthProvider>
  );
}
