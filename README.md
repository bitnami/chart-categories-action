# Charts Categories GitHub Action

This action checks that all the Helm Charts in the repository have a category and the category belongs to a pre-defined list of categories.

The categories should be set at the `Chart.yaml` file in the way:

```
annotations:
  category: category-name
```

## Inputs

### `command`

**Required** The command to pass to the `category-checker.sh` script. **Default**: `check-categories`. (At this moment only `check-categories` is supported)

### `categories-file`

The path to the file containing the categories inside your Helm Chart repository. **Default**: `CHART_CATEGORIES`.

## Outputs

### `categories-are-correct`

Whether or not the changed Helm Charts have a correct category.

## Example usage

```
check-categories:
  runs-on: ubuntu-latest
  steps:
    - name: Checkout
      uses: actions/checkout@v2

    - name: Fetch history
      run: git fetch --prune --unshallow

    - name: Check categories
      uses: kungze/chart-categories-action@main
      with:
        command: 'check-categories'
        categories-file: 'my_Categories_file'
```

See: https://github.com/bitnami/charts/blob/master/.github/workflows/lint-test.yaml

## Pending improvements

- [X] Add option to pass your own list of categories.

## How to debug this action locally

Build the docker image:

```
docker build . -t <image-name>
```

Run the image mounting your Helm Charts repository:

```
docker run --rm -v <absolute-path-to-your-repo>:/github/workspace --workdir /github/workspace -it <image-name> check-categories
```
