#TableView and iPad
##TableView
Plain (Ungrouped) and Grouped

Components of table view:</br>
Table header</br>
Sections (header, footer, cells/rows)</br>
Table footer

Section is a way to group the rows

Different cell types (and can have custom cell types)

Will want to implement delegate and data source to populate the table view

The purpose of the cell reuseidentifier is to indicate what type of cell we want and if one exists then we just reuse the old cell so that we don't have to deallocate and allocate cells indefinitely which would cause a big drop in performance

If you want to reload the table call reloadData
