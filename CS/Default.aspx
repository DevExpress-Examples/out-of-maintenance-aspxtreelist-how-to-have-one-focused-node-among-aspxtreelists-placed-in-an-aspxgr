<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.ASPxTreeList.v17.1, Version=17.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTreeList" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v17.1, Version=17.1.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        detailTreeLists = {};

        function onTreeListInit(s, e) {
            detailTreeLists[s.name] = s;
            ValidateFocusedNode(s);
        }

        function onTreeListEndCallback(s, e) {
            ValidateFocusedNode(s);
        }

        function onTreeListFocusedNodeChanged(s, e) {
            var focusedControls = GetAllFocusedTreeListsOnPage();
            for (var i = 0; i < focusedControls.length; i++) {
                var control = focusedControls[i];
                if (control !== s)
                    control.SetFocusedNodeKey(null);
            }
        }

        function ValidateFocusedNode(treeList) {
            var focusedControls = GetAllFocusedTreeListsOnPage();
            if (focusedControls.length > 1 && focusedControls.indexOf(treeList) > -1)
                treeList.SetFocusedNodeKey(null);
        }

        function GetAllFocusedTreeListsOnPage() {
            var result = [];
            for (var treeListName in detailTreeLists) {
                var treeList = detailTreeLists[treeListName];
                var focusedNodeKey = treeList.GetFocusedNodeKey();
                if (!treeList.GetMainElement() || focusedNodeKey === null || focusedNodeKey === "")
                    continue;
                result.push(treeList);
            }
            return result;
        }

        function removeOutdatedTreeLists() {
            var treeListsForRemoving = [];

            for (var treeListName in detailTreeLists) {
                var treeList = detailTreeLists[treeListName];
                if (!treeList.GetMainElement())
                    treeListsForRemoving.push(treeListName);
            }

            for (var i = 0; i < treeListsForRemoving.length; i++)
                delete detailTreeLists[treeListsForRemoving[i]];
        }

        function onGridEndCallback(s, e) {
            removeOutdatedTreeLists();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:AccessDataSource ID="firstAccessDataSource" runat="server" DataFile="~/nwind.mdb" SelectCommand="SELECT OrderID, CustomerID, EmployeeID FROM Orders" />
        <asp:AccessDataSource ID="secondAccessDataSource" runat="server" DataFile="~/nwind.mdb" SelectCommand="SELECT FirstName, LastName, ReportsTo FROM Employees" />
        <dx:ASPxGridView ID="ASPxGridView1" runat="server" DataSourceID="firstAccessDataSource" KeyFieldName="OrderID">
            <ClientSideEvents EndCallback="onGridEndCallback" />
            <SettingsDetail ShowDetailRow="true" />
            <Styles AlternatingRow-Enabled="True" />
            <Templates>
                <DetailRow>
                    <dx:ASPxTreeList ID="ASPxTreeList" runat="server" ClientInstanceName="DetailTreeList" SettingsPager-PageSize="2" SettingsPager-Mode="ShowPager" KeyFieldName="FirstName, LastName"
                        ParentFieldName="ReportsTo" DataSourceID="secondAccessDataSource">
                        <ClientSideEvents Init="onTreeListInit" EndCallback="onTreeListEndCallback" FocusedNodeChanged="onTreeListFocusedNodeChanged" />
                        <Columns>
                            <dx:TreeListDataColumn FieldName="FirstName" />
                            <dx:TreeListDataColumn FieldName="LastName" />
                        </Columns>
                        <SettingsBehavior AllowFocusedNode="True" AllowSort="true" />
                    </dx:ASPxTreeList>
                </DetailRow>
            </Templates>
        </dx:ASPxGridView>
    </form>
</body>
</html>
