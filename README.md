# Charts Categories GitHub Action

This action checks that all the Helm Charts in the repository have a category and the category belongs to a pre-defined list of categories.

The categories should be set at the `Chart.yaml` file in the way:

```
annotations:
  category: category-name
```

## Inputs

### `command`

**Required** The command to pass to the `category-checker.sh` script. Default `check-categories`. (At this moment only `check-categories` is supported)

## Outputs

### `categories-are-correct`

Whether or not the changed Helm Charts have a correct category.

## Example usage

```
uses: bitnami/chart-categories-action@master
with:
  command: 'check-categories'
```

See: https://github.com/bitnami/charts/blob/master/.github/workflows/lint-test.yaml

## Pending improvements

- Add option to pass your own list of categories.

## How to debug this action locally

Build the docker image:

```
docker build . -t <image-name>
```

Run the image mounting your Helm Charts repository:

```
docker run --rm -v <absolute-path-to-your-repo>:/github/workspace --workdir /github/workspace -it <image-name> check-categories
```
