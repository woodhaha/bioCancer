> Create pivot tables to explore your data

If you have used pivot-tables in Excel the functionality provided in the Pivot tab should be familiar to you. Similar to the Explore tab, you can generate summary statistics for variables in your data. You can also easily generate frequency tables. Perhaps the most powerful feature in Pivot is that you can describe the data _by_ one or more other variables.

For example, with the `epiGenomics` data select `Genes`, `Diseases` and `CNA`  from the Categorical variables drop-down. You can drag-and-drop the selected variables to change their order. The categories for the first variable will be the column headers. After selecting these three variables a frequency table of  data with different Diseases and Genes. Choose `Row`, `Column`, or `Total` from the Normalize drop-down to normalize the frequencies by row, column, or overall total. If a normalize option is selected it can be convenient to check the `Percentage` box to express the numbers as percentages. Choose `Color bar` or `Heat map` from the Conditional formatting drop-down to emphasize the highest frequency counts.

It is also possible to summarize numerical variables. Select `FreqMut` from the Numerical variables drop-down. This will create the table shown below. Just as in the View tab you can sort the table by clicking on the column headers. You can also use sliders (e.g., click in the input box below `I1`) to limit the view to values in a specified range. To view only information for `CNA` with `0` or `-1` levels click in the input box below the `CNA` header.

![pivotr table](figures/pivotr.png)

You can also create a bar chart based on the generated table (see image above). To download the table to _csv_ format or the plot to a _png_ format click the download icon on the right.

### Filter

Use the `Filter` box to select (or omit) specific sets of rows from the data. See the help file for Data > View for details.
