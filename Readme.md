<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128548190/17.1.7%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/T570802)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->
<!-- default file list -->
*Files to look at*:

* [Default.aspx](./CS/Default.aspx) (VB: [Default.aspx](./VB/Default.aspx))
* [Default.aspx.cs](./CS/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/Default.aspx.vb))
<!-- default file list end -->
# ASPxTreeList - How to have one focused node among ASPxTreeLists placed in an ASPxGridView detail row
<!-- run online -->
**[[Run Online]](https://codecentral.devexpress.com/t570802/)**
<!-- run online end -->


<p>This example demonstrates how to have one focused node within several ASPxTreeLists located in an ASPxGridView detail row template.</p>
<p>Add the <strong><em>detailTreeLists </em></strong>JavaScript dictionary to store the ASPxTreeLists currently displayed in ASPxGridView.</p>


```js
detailTreeLists = {};
```


<p>Add the <strong><em>GetAllFocusedTreeListsOnPage </em></strong>JavaScript function to get all focused ASPxTreeLists within ASPxGridView. After that, add the <strong><em>ValidateFocusedNode</em></strong> JavaScript function to check if a node has been focused in every displayed ASPxTreeList. If so, the <a href="https://documentation.devexpress.com/AspNet/DevExpress.Web.ASPxTreeList.Scripts.ASPxClientTreeList.SetFocusedNodeKey.method">ASPxClientTreeList.SetFocusedNodeKey</a> method call will reset the ASPxTreeList focused node.</p>


```js
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

function ValidateFocusedNode(treeList) {
    var focusedControls = GetAllFocusedTreeListsOnPage();
    if (focusedControls.length > 1 && focusedControls.indexOf(treeList) > -1)
        treeList.SetFocusedNodeKey(null);
}
```


<p>Assign the <strong><em>onTreeListInit</em></strong> function as the <a href="https://documentation.devexpress.com/AspNet/DevExpress.Web.Scripts.ASPxClientControlBase.Init.event">ASPxClientTreeList.Init</a> event handler to add newly displayed ASPxTreeLists into <strong><em>detailTreeLists </em></strong>and call the <strong><em>ValidateFocusedNode</em></strong> function. In addition, assign the <strong><em>onTreeListEndCallback</em></strong> function as the <a href="https://documentation.devexpress.com/AspNet/DevExpress.Web.ASPxTreeList.Scripts.ASPxClientTreeList.EndCallback.event">ASPxClientTreeList.EndCallback</a> event handler and call <strong><em>ValidateFocusedNode</em></strong>.</p>


```js
function onTreeListInit(s, e) {
    detailTreeLists[s.name] = s;
    ValidateFocusedNode(s);
}

function onTreeListEndCallback(s, e) {
    ValidateFocusedNode(s);
}
```


<p>To reset the focused node in ASPxTreeLists which are not currently focused by the user, assign the <strong><em>onTreeListFocusedNodeChanged</em></strong> function as the <a href="https://documentation.devexpress.com/AspNet/DevExpress.Web.ASPxTreeList.Scripts.ASPxClientTreeList.FocusedNodeChanged.event">ASPxClientTreeList.FocusedNodeChanged</a> event handler.</p>


```js
function onTreeListFocusedNodeChanged(s, e) {
    var focusedControls = GetAllFocusedTreeListsOnPage();
    for (var i = 0; i < focusedControls.length; i++) {
        var control = focusedControls[i];
        if (control !== s)
            control.SetFocusedNodeKey(null);
    }
}
```


<p>Add the <strong><em>removeOutdatedTreeLists</em></strong> JavaScript function to remove the ASPxTreeLists which are not currently displayed from <strong><em>detailTreeLists</em></strong>. After that, call <strong><em>removeOutdatedTreeLists </em></strong>in the<em> </em><strong><em>onGridEndCallback </em></strong>handler of the <a href="https://documentation.devexpress.com/AspNet/DevExpress.Web.Scripts.ASPxClientGridView.EndCallback.event">ASPxClientGridView.EndCallback</a> event.</p>


```js
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
```



<br/>


