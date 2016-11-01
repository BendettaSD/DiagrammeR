#' Delete one of the global graph attributes stored
#' within a graph object
#' @description Delete one of the global attributes
#' stored within a graph object of class
#' \code{dgr_graph}).
#' @param graph a graph object of class
#' \code{dgr_graph} that is created using
#' \code{create_graph}.
#' @param attr the name of the attribute to
#' delete for the \code{type} of global attribute
#' specified.
#' @param attr_type the specific type of global graph
#' attribute to delete. The type is specified with
#' \code{graph}, \code{node}, or \code{edge}.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' # Create a new graph and add some global attributes
#' graph <-
#'   create_graph() %>%
#'   add_global_graph_attrs(
#'     "overlap", "true", "graph") %>%
#'   add_global_graph_attrs(
#'     "penwidth", 3, "node") %>%
#'   add_global_graph_attrs(
#'     "penwidth", 3, "edge")
#'
#' # View the graph's global attributes
#' get_global_graph_attrs_v2(graph)
#' #>       attr value attr_type
#' #> 1  overlap  true     graph
#' #> 2 penwidth     3      node
#' #> 3 penwidth     3      edge
#'
#' # Delete the `penwidth` attribute for the graph's
#' # nodes using `delete_global_graph_attrs()`
#' graph <-
#'   graph %>%
#'   delete_global_graph_attrs("penwidth", "node")
#'
#' # View the remaining set of global
#' # attributes for the graph
#' get_global_graph_attrs_v2(graph)
#' #>       attr value attr_type
#' #> 1 penwidth     3      edge
#' #> 2  overlap  true     graph
#' @importFrom dplyr anti_join
#' @importFrom tibble tibble
#' @export delete_global_graph_attrs

delete_global_graph_attrs <- function(graph,
                                      attr,
                                      attr_type) {

  # Get the global graph attributes already set
  # in the graph object
  global_attrs_available <- graph$global_attrs

  # Create a table with a single row for the
  # attribute to remove
  global_attrs_to_remove <-
    tibble::tibble(
      attr = as.character(attr),
      value = as.character(NA),
      attr_type = as.character(attr_type)) %>%
    as.data.frame(stringsAsFactors = FALSE)

  # Use the `anti_join()` to remove global attribute
  # rows from the graph
  global_attrs_joined <-
    global_attrs_available %>%
    dplyr::anti_join(global_attrs_to_remove,
                     by = c("attr",
                            "attr_type"))

  # Replace the graph's global attributes with
  # the revised set
  graph$global_attrs <- global_attrs_joined

  return(graph)
}