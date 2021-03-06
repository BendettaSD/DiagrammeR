#' Get information on a graph series
#' @description Obtain a data frame with information
#' on the graphs within a graph series.
#' @param graph_series a graph series object of type
#' \code{dgr_graph_1D}.
#' @return a data frame containing information on the
#' graphs within the supplied graph series.
#' @examples
#' # Create three graphs
#' graph_1 <-
#'   create_graph() %>%
#'   add_n_nodes(n = 3) %>%
#'   add_edges_w_string(
#'     edges = "1->3 1->2 2->3")
#'
#' graph_2 <-
#'   graph_1 %>%
#'   add_node() %>%
#'   add_edge(from = 4, to = 3)
#'
#' graph_3 <-
#'   graph_2 %>%
#'   add_node() %>%
#'   add_edge(from = 5, to = 2)
#'
#' # Create an empty graph series and add
#' # the graphs
#' series <-
#'   create_series() %>%
#'   add_to_series(
#'     graph_1,
#'     graph_series = .) %>%
#'   add_to_series(
#'     graph_2,
#'     graph_series = .) %>%
#'   add_to_series(
#'     graph_3,
#'     graph_series = .)
#'
#' # Get information on the graphs in the series
#' series_info(series)
#' #>   graph name date_time   tz nodes edges directed
#' #> 1     1 <NA>      <NA> <NA>     3     3     TRUE
#' #> 2     2 <NA>      <NA> <NA>     4     4     TRUE
#' #> 3     3 <NA>      <NA> <NA>     5     5     TRUE
#' @export series_info

series_info <- function(graph_series) {

  graphs_in_series <-
    graph_count(graph_series)

  series_info_df <-
    data.frame(
      graph = as.integer(NA),
      name = as.character(NA),
      date_time = Sys.time(),
      tz = as.character(NA),
      nodes = as.integer(NA),
      edges = as.integer(NA),
      directed = as.logical(NA),
      stringsAsFactors = FALSE)[-1, ]

  if (graphs_in_series == 0) {
    return(series_info_df)
  }

  for (i in 1:graphs_in_series) {

    # Add a graph index number
    series_info_df[i, 1] <- i

    # Add the graph name
    series_info_df[i, 2] <-
      graph_series$graphs[[i]]$graph_info$graph_name

    # Add the graph time
    series_info_df[i, 3] <-
      as.POSIXct(
        graph_series$graphs[[i]]$graph_info$graph_time,
        tz = graph_series$graphs[[i]]$graph_info$graph_tz,
        origin = "1970-01-01")

    # Add the graph time zone
    series_info_df[i, 4] <-
      graph_series$graphs[[i]]$graph_info$graph_tz

    # Add the count of nodes in the graph
    series_info_df[i, 5] <-
      nrow(graph_series$graphs[[i]]$nodes_df)

    # Add the count of nodes in the graph
    series_info_df[i, 6] <-
      nrow(graph_series$graphs[[i]]$edges_df)

    # Add TRUE/FALSE value on whether graph is directed
    series_info_df[i, 7] <-
      is_graph_directed(graph_series$graphs[[i]])
  }

  return(series_info_df)
}
