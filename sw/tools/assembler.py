import click

    
@click.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.argument("output_file", type=click.Path(exists=False))
def assemble(input_file, output_file):
    print(f"Assembling {input_file} to {output_file}")

if __name__ == "__main__":
    assemble()