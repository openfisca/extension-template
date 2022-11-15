"""This file defines an additional variable for the modelled legislation.

A variable is a property of an Entity such as a Person, a Household…

See https://openfisca.org/doc/key-concepts/variables.html

"""

# Import from openfisca-core the Python objects used to code the legislation
from openfisca_core import periods, variables

# Import the entities specifically defined for this tax and benefit system
from openfisca_country_template import entities


class local_town_child_allowance(variables.Variable):
    value_type = float
    entity = entities.Household
    definition_period = periods.MONTH
    label = "Local benefit: a fixed amount by child each month"

    def formula(self, period, parameters):
        """Local benefit.

        Extensions can only add variables and parameters to the tax and benefit
        system (they cannot modify or neutralize existing ones).

        Args:
            period: The period of the variable.
            parameters: Parameters that are used in the formula.

        Returns:
            The amount per child multiplied by the number of children, for each
            household in `family`.

        """
        nb_children = self.nb_persons(role = entities.Household.CHILD)

        amount_per_child = parameters(period).local_town.child_allowance.amount

        return nb_children * amount_per_child
