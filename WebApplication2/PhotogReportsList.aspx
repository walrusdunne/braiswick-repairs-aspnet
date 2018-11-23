﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PhotogReportsList.aspx.cs" Inherits="WebApplication2.PhotogReportsList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="headextra" runat="server">
    <style>
        * {
            font-family: Ubuntu, sans-serif;
        }

        .top10 {
            margin-top: 10px;
        }

        #searchTermsList {
            display: inline-block;
        }

        div[id^="filter_"] {
            display: inline-block;
            border: 2px solid #286090;
            border-radius: 10px;
            padding: 3px 6px;
            background-color: #337ab7;
            box-shadow: 1px 1px 5px 0px rgba(0,0,0,0.75);
            margin: 0px 3px;
            color: white;
        }

        div.or[id^="filter_"] {
            background-color: #286090;
            border-color: #204d74;
        }

        span.filter-close {
            border: 2px solid #c9302c;
            border-radius: 50%;
            padding: 0px 4px;
            cursor: pointer;
            background-color: #d9534f;
            color: white;
        }

        span.filter-close:hover {
            background-color: #c9302c;
            border-color: #ac2925;
        }

        span.filter-text {
            padding-left: 5px;
            padding-right: 3px;
        }

        #temploadmore {
            text-align: center;
        }

        .center-button {
            width: 100%;
            text-align: center;
        }

        .column-sort-icon {
            display: inline;
            margin-left: 5px;
        }

        a.column-sort {
            text-decoration: none !important;
            cursor: pointer;
        }

        @media print {
            a[href]:after {
                content: "" !important;
            }
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-xs-12 form-inline top10">
            <div class="inner-addon left-addon">
                <i class="glyphicon glyphicon-search"></i>
                <select id="equationSelect" class="form-control hidden">
                    <option value=">" title="Greater">></option>
                    <option value="<" title="LessThan"><</option>
                    <option value="=" title="Equals">=</option>
                </select>
                <input type="date" id="dateSearch" onchange="dateSearch()" class="form-control hidden" />
                <input type="number" id="costSearch" onchange="costSearch()" class="form-control hidden" />
                <input type="text" id="equipSearch" onkeyup="searchFilter()" placeholder="Search..." class="form-control">
                <select id="searchCol" class="form-control" onchange="changeSearch()">
                    <option value="0" title="ID">ID</option>
                    <option value="1" title="Date">Date</option>
                    <option value="2" title="Office">Office</option>
                    <option value="3" title="Job">Job</option>
                    <option value="4" title="School">School</option>
                    <option value="5" title="Type">Type</option>
                    <option value="6" title="Cost">Cost</option>
                    <option value="7" title="Initials">Initials</option>
                    <option value="8" title="Status">Status</option>
                    <option value="9" title="Notes">Notes</option>
                </select>
                <button type="button" id="addFilterButton" class="btn btn-primary" onclick="addFilter(); return false;">+</button>
                <button type="button" id="clearAllFilters" class="btn btn-danger" onclick="clearFilters(); return false;">&times;</button>
                <div id="searchTermsList"></div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12 top10">
            <asp:GridView ID="reportsList" runat="server" GridLines="None" CssClass="table table-striped table-hover" AllowSorting="true" OnRowDataBound="reportsList_RowDataBound" OnSorting="reportsList_Sorting"></asp:GridView>
            <table id="reportsdata" class="table table-striped table-hover">
                <thead id="reportsdataHead"></thead>
                <tbody id="reportsdataBody"></tbody>
            </table>
            <div class="center-button">
                <a class="btn btn-danger" id="temploadmore">Load more...</a>
                <!--<a class="btn btn-warning" id="loadall">Show all</a>-->
            </div>
        </div>
    </div>

    <script src="Scripts/purl.js"></script>
    <script>
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip();
        });

        $('#temploadmore').on('click', function () {
            progLoadTable();
        });

        $('#loadall').on('click', function () {
            progLoadTable(true);
        })

        $('#reportsdataHead').on('click', '.column-sort', function () {
            $('.column-sort-icon').removeClass('glyphicon glyphicon-chevron-up glyphicon-chevron-down');
            var newSortColumn = $(this).attr('data-sort-column');
            var newSortDirection = newSortColumn == lastSortColumn ? (lastSortDirection == 'ASC' ? 'DESC' : 'ASC') : 'ASC';
            sortList(newSortColumn, newSortDirection);
            lastSortColumn = newSortColumn;
            lastSortDirection = newSortDirection;
            var columnIcon = '.column-sort-icon[data-sort-column=\'' + newSortColumn + '\']';
            $(columnIcon).addClass(newSortDirection == 'ASC' ? 'glyphicon glyphicon-chevron-up' : 'glyphicon glyphicon-chevron-down');
        })

        var searchTerms = [];

        var myList;

        var currentList;

        var searchList = [];

        var headersDrawn = false;

        var masterColumnSet;

        var tableIndex = 0;

        var queryParams;

        var lastSortColumn = 'ID';
        var lastSortDirection = 'DESC';

        pageStart();

        async function pageStart() {
            await getPReportsData();
            getParams();
        }

        function getParams() {
            queryParams = purl().param();
            var paramSearch = [
                ["id", "ID", 0],
                ["date", "Date", 1],
                ["office", "Office", 2],
                ["job", "Job", 3],
                ["school", "School", 4],
                ["type", "Type", 5],
                ["cost", "Cost", 6],
                ["initials", "Initials", 7],
                ["status", "Status", 8],
                ["notes", "Notes", 9]
            ]
            for (i = 0; i < paramSearch.length; i++) {
                if (queryParams[paramSearch[i][0]]) {
                    if (Array.isArray(queryParams[paramSearch[i][0]])) {
                        searchTerms.push({ 'columnName': paramSearch[i][1], 'columnIndex': paramSearch[i][2], 'searchTerm': queryParams[paramSearch[i][0]] });
                    } else {
                        searchTerms.push({ 'columnName': paramSearch[i][1], 'columnIndex': paramSearch[i][2], 'searchTerm': [queryParams[paramSearch[i][0]]] });
                    }
                }
            }
            writeFilters();
            searchFilter();
        }
        //var statusParam = $.url(window.location.href).param('status');
        //if (statusParam == 'report') {
        //    searchTerms.push({ 'columnIndex': 8, 'columnName': 'Status', 'searchTerm': ['REPORT'] });
        //    writeFilters();
        //    searchFilter();
        //}

        function costSearch() {
            var e = document.getElementById('equationSelect');
            e.options[0].text = ">";
            e.options[1].text = "<";
            e.options[2].text = "=";
            document.getElementById('equationSelect').className = "form-control";
            document.getElementById('costSearch').className = "form-control";
            document.getElementById('equipSearch').className = "form-control hidden";
        }

        function dateSearch() {
            var e = document.getElementById('equationSelect');
            e.options[0].text = "After";
            e.options[1].text = "Before";
            e.options[2].text = "On";
            document.getElementById('equationSelect').className = "form-control";
            document.getElementById('dateSearch').className = "form-control";
            document.getElementById('equipSearch').className = "form-control hidden";
        }

        function resetSearch() {
            document.getElementById('equipSearch').value = "";
            document.getElementById('equationSelect').className = "form-control hidden";
            document.getElementById('costSearch').className = "form-control hidden";
            document.getElementById('dateSearch').className = "form-control hidden";
            document.getElementById('equipSearch').className = "form-control";
        }

        function innerSearch(j, td, filter, currentCount) {
            var count = currentCount;
            var tdv = td.toString();
            var searchTerm;
            var innerCount = 0;

            for (i = 0; i < filter.searchTerm.length; i++) {
                searchTerm = filter.searchTerm[i].toUpperCase();
                if (tdv) {
                    if (j == 6) {
                        var costValue = parseFloat(searchTerm.substr(1));
                        if (searchTerm.substr(0, 1) == ">" && searchTerm.length >= 2) {
                            count = parseFloat(tdv) > costValue ? count : count + 1;
                        } else if (searchTerm.substr(0, 1) == "<" && searchTerm.length >= 2) {
                            count = parseFloat(tdv) <= costValue ? count : count + 1;
                        } else if (searchTerm.substr(0, 1) == "=" && searchTerm.length >= 2) {
                            count = parseFloat(tdv) == costValue ? count : count + 1;
                        }
                    } else if (j == 1) {
                        var dateSearch = new Date(searchTerm.substr(1));
                        var dateTD = new Date(tdv);
                        if (searchTerm.substr(0, 1) == ">" && searchTerm.length >= 11) {
                            count = dateTD >= dateSearch ? count : count + 1;
                        } else if (searchTerm.substr(0, 1) == "<" && searchTerm.length >= 11) {
                            count = dateTD <= dateSearch ? count : count + 1;
                        } else if (searchTerm.substr(0, 1) == "=" && searchTerm.length >= 11) {
                            count = dateTD.valueOf() == dateSearch.valueOf() ? count : count + 1;
                        }
                    } else {
                        if (tdv.toUpperCase().indexOf(searchTerm) > -1) {
                            innerCount = innerCount + 1;
                        }
                    }
                } else {

                }
            }

            if (innerCount === 0 && j != 6 && j != 1) {
                count = count + 1;
            }

            if (tdv == "" && j == 1) {
                count = count + 1;
            }
            
            return count;
        }

        function changeSearch() {
            var e = document.getElementById('searchCol');
            var col = parseInt(e.options[e.selectedIndex].value);
            if (col == 1) {
                resetSearch();
                searchFilter();
                dateSearch();
            } else if (col == 6) {
                resetSearch();
                searchFilter();
                costSearch();
            } else {
                resetSearch();
                searchFilter();
            }
        }

        function searchFilter() {
            searchList = [];
          // Declare variables
          var input, filter, table, tr, td, i, ii, current, col, colName, e;
          input = document.getElementById('equipSearch');
          filter = input.value.toUpperCase();
          //table = document.getElementById("<%= reportsList.ClientID %>");
          //tr = table.getElementsByTagName("tr");
        e = document.getElementById('searchCol');
            col = parseInt(e.options[e.selectedIndex].value);
            colName = e.options[e.selectedIndex].text;
        var liveSearch = { 'columnName': colName, 'columnIndex': col, 'searchTerm': [filter] };

            var searchNow = JSON.parse(JSON.stringify(searchTerms));
            var searchExists = false;
            for (f = 0; f < searchNow.length; f++) {
                if (searchNow[f].columnIndex == col) {
                    if (filter != "") {
                        searchNow[f].searchTerm.push(filter);
                        searchExists = true;
                    } else {

                    }
                }
            }
            if (!searchExists) {
                searchNow.push(liveSearch);
            }
        

          // Loop through all table rows, and hide those who don't match the search query
            for (i = 0; i < myList.length; i++) {
              var count = 0;
              //for (j = col; j < col + 1; j++) {
              //    td = tr[i].getElementsByTagName("td")[j];
              //    count = innerSearch(j, td, liveSearch, count);
              //}
              for (jj = 0; jj < searchNow.length; jj++) {
                  var column = parseInt(searchNow[jj].columnIndex);
                  td = myList[i][searchNow[jj].columnName];
                  count = innerSearch(column, td, searchNow[jj], count);
              }
              if (count > 0) {
                  //tr[i].style.display = "none";
              } else {
                  //tr[i].style.display = "";
                  searchList.push(myList[i]);
              }
            }
            var tbody = document.getElementById('reportsdataBody');
            tbody.innerHTML = "";

            //remove next line?
            tableIndex = 0;

            currentList = searchList;
            buildHtmlTable('#reportsdataBody', currentList);
        }

        function sortList(sortColumn, direction) {
            var sortedList = myList.sort(compare(sortColumn, direction));
            myList = sortedList;
            searchFilter();
        }

        function compare(sortColumn, direction) {
            return function(a, b) {
                if (a[sortColumn] < b[sortColumn])
                    return direction == 'ASC' ? -1 : 1;
                if (a[sortColumn] > b[sortColumn])
                    return direction == 'ASC' ? 1 : -1;
                return 0;
            }
        }

        function addFilter() {
            var colName, colIndex, searchTerm, e;
            var exisiting = -1;
            e = document.getElementById('searchCol');
            colName = e.options[e.selectedIndex].text;
            colIndex = parseInt(e.options[e.selectedIndex].value);

            if (colIndex == 1) {
                searchTerm = document.getElementById('equationSelect').value + document.getElementById('dateSearch').value;
            } else if (colIndex == 6) {
                searchTerm = document.getElementById('equationSelect').value + document.getElementById('costSearch').value;
            } else {
                searchTerm = document.getElementById('equipSearch').value;
            }

            for (i = 0; i < searchTerms.length; i++) {
                if (searchTerms[i].columnIndex == colIndex) {
                    exisiting = i;
                }
            }
            if (exisiting > -1) {
                searchTerms[exisiting].searchTerm.push(searchTerm);
            } else {
                searchTerms.push({ 'columnName': colName, 'columnIndex': colIndex, 'searchTerm': [searchTerm] });
            }
            writeFilters();
            document.getElementById('equipSearch').value = "";
            searchFilter();
        }

        function clearFilters() {
            document.getElementById('equipSearch').value = "";
            searchTerms = [];
            writeFilters();
            searchFilter();
        }

        function removeFilter(index) {
            searchTerms.splice(parseInt(index), 1);
            writeFilters();
            searchFilter();
        }

        function writeFilters() {
            var filtersHTML = '<div class="filters">';
            for (i = 0; i < searchTerms.length; i++) {
                var searchTermHTML = "";
                for (ii = 0; ii < searchTerms[i].searchTerm.length; ii++) {
                    if (ii > 0) {
                        if (searchTerms[i].columnIndex == 6 || searchTerms[i].columnIndex == 1) {
                            searchTermHTML += " and ";
                        } else {
                            searchTermHTML += " or ";
                        }
                    }
                    searchTermHTML += "<strong>" + searchTerms[i].searchTerm[ii] + "</strong>";
                }
                var classes = searchTerms[i].searchTerm.length > 1 ? "filter or" : "filter";
                filtersHTML += '<div class="' + classes + '" id="filter_' + i + '"><span class="filter-close" onclick="removeFilter(' + i + ')">&times;</span><span class="filter-text">' + searchTerms[i].columnName + ': ' + searchTermHTML + '</span></div>';
            }
            filtersHTML += '</div>';
            document.getElementById('searchTermsList').innerHTML = filtersHTML;
            writeQueryString();
        }

        function writeQueryString() {
            var queryString = "";
            var count = 0;
            for (i = 0; i < searchTerms.length; i++) {
                for (ii = 0; ii < searchTerms[i].searchTerm.length; ii++) {
                    var queryStringPart;
                    if (count == 0) {
                        queryStringPart = "?" + searchTerms[i].columnName.toLowerCase() + "=" + searchTerms[i].searchTerm[ii];
                    } else {
                        queryStringPart = "&" + searchTerms[i].columnName.toLowerCase() + "=" + searchTerms[i].searchTerm[ii];
                    }
                    queryString += queryStringPart;
                    count++;
                }
            }
            var fullURL = purl().attr('source');
            var exisitingParams = "";
            if (fullURL.indexOf('?') > -1) {
                exisitingParams = fullURL.substr(fullURL.indexOf('?'));
            }
            var url = fullURL.substr(0, fullURL.length - exisitingParams.length);
            var newURL = url + queryString;
            history.pushState('', 'Braiswick', newURL);
            document.getElementsByTagName("form")[0].setAttribute('action', './PhotogReportsList' + queryString);
        }

        async function getPReportsData() {
            await $.ajax({
                type: 'POST',
                dataType: 'json',
                contentType: 'application/json',
                url: 'ColumnChart.asmx/GetReports',
                data: '{}',
                success: function (response) {
                    setPReportsData(response.d);
                },

                error: function () {
                    alert("Error loading data! Please try again.");
                }
            });
            return;
        }

        function setPReportsData(tableinputdata) {
            myList = tableinputdata;
            currentList = myList;
            buildHtmlTable('#reportsdataBody', currentList);
        }

        function buildHtmlTable(selector, buildList, showall = false) {
            var columns;
            var endOfRecords = false;
            if (!headersDrawn) columns = addAllColumnHeaders(buildList, '#reportsdataHead');
            else columns = masterColumnSet;

            var tableIndexUpper;
            if (buildList.length - tableIndex > 100) tableIndexUpper = tableIndex + 100;
            else {
                tableIndexUpper = buildList.length;
                endOfRecords = true;
            }

            if (showall) tableIndexUpper = buildList.length;

            for (var i = tableIndex; i < tableIndexUpper; i++) {
                var row$ = $('<tr/>');
                for (var colIndex = 0; colIndex < columns.length; colIndex++) {
                    if (colIndex != 8 && colIndex != 9) {
                        var cell$ = $('<td/>');
                        var cellValue = buildList[i][columns[colIndex]];
                        if (cellValue == null) cellValue = "";
                        if (colIndex == 0) cellValue = '<a class="btn btn-primary" href="PhotogReports.aspx?id=' + buildList[i][columns[colIndex]] + '">' + buildList[i][columns[colIndex]] + '</a>';
                        if (colIndex == 7) cellValue = '<a class="btn btn-default" href="PhotogDetails.aspx?photogID=' + buildList[i][columns[colIndex]] +
                            '" data-toggle="tooltip" data-placement="right" data-html="true" title="" data-original-title="ID: ' + buildList[i][columns[colIndex]] +
                            '</br>' + buildList[i][columns[9]] + '">' + buildList[i][columns[8]] + '</a>';
                        row$.append(cell$.html(cellValue));
                    }
                }
                $(selector).append(row$);
            }

            if (endOfRecords || showall) {
                $('#temploadmore').addClass('disabled');
                $('#temploadmore').text("End of results");
            } else {
                $('#temploadmore').removeClass('disabled');
                $('#temploadmore').text("Load more...");
            }

            tableIndex = tableIndexUpper;
            $('[data-toggle="tooltip"]').tooltip();
        }

        // Adds a header row to the table and returns the set of columns.
        // Need to do union of keys from all records as some records may not contain
        // all records.
        function addAllColumnHeaders(myList, selector) {
            var columnSet = [];
            var headerTr$ = $('<tr/>');

            for (var i = 0; i < myList.length; i++) {
                var rowHash = myList[i];
                for (var key in rowHash) {
                    if ($.inArray(key, columnSet) == -1) {
                        columnSet.push(key);
                        if (key != 'Initials' && key != 'Name') headerTr$.append($('<th/>').html('<a class="column-sort" data-sort-column="' + key + '">' + key +'<span class="column-sort-icon" data-sort-column="' + key + '"></span></a>'));
                    }
                }
            }
            $(selector).append(headerTr$);

            masterColumnSet = columnSet;
            headersDrawn = true;
            return columnSet;
        }

        function progLoadTable(showall = false) {
            buildHtmlTable('#reportsdata', currentList, showall);
        }
    </script>
</asp:Content>
