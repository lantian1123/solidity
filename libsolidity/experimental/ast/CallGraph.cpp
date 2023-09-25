/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0

#include <libsolidity/experimental/ast/CallGraph.h>

using namespace solidity::frontend::experimental;

// TODO remove before merge (delete entire file)
std::ostream& solidity::frontend::experimental::operator<<(std::ostream& _out, CallGraph const& _callGraph)
{
	_out << "EDGES" << "\n";
	_out << "===================" << std::endl;
	for (auto [top, subs]: _callGraph.edges)
	{
		std::string topName = top->name().empty() ? "fallback" : top->name();
		_out << "(" << topName <<") --> {";
		for (auto sub: subs)
		{
			_out << sub->name() << ",";
		}
		_out << "}" << std::endl;
	}

	_out << "\nREVERSE EDGES" << "\n";
	_out << "===================" << std::endl;
	for (auto [top, subs]: _callGraph.reverseEdges)
	{
		std::string topName = top ? top->name() : "nullptr";
		_out << "(" << topName <<") --> {";
		for (auto sub: subs)
		{
			std::string subName = sub->name().empty() ? "fallback" : sub->name();
			_out << subName << ",";
		}
		_out << "}" << std::endl;
	}

	return _out;
}
