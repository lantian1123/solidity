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

#include <libsolidity/experimental/analysis/Analysis.h>
#include <libsolidity/experimental/analysis/FunctionCallGraph.h>

using namespace solidity::frontend::experimental;
using namespace solidity::util;

FunctionCallGraph::FunctionCallGraph(solidity::frontend::experimental::Analysis& _analysis):
	m_analysis(_analysis),
	m_errorReporter(_analysis.errorReporter()),
	m_currentNode(nullptr),
	m_inFunctionDefinition(false)
{
}

bool FunctionCallGraph::analyze(SourceUnit const& _sourceUnit)
{
	_sourceUnit.accept(*this);
	// TODO remove debug output before merge
	//std::cout << annotation().functionCallGraph << std::endl;
	return !m_errorReporter.hasErrors();
}

bool FunctionCallGraph::visit(FunctionDefinition const& _functionDefinition)
{
	m_inFunctionDefinition = true;
	m_currentNode = &_functionDefinition;
	return true;
}

void FunctionCallGraph::endVisit(FunctionDefinition const&)
{
	// If we're done visiting a function declaration without said function referencing/calling
	// another function in its body - insert it into the graph without child nodes.
	if (!annotation().functionCallGraph.edges.count(m_currentNode))
	{
		annotation().functionCallGraph.edges.insert({m_currentNode, {}});
		annotation().functionCallGraph.reverseEdges[nullptr].insert(m_currentNode);
	}
	m_inFunctionDefinition = false;
}

bool FunctionCallGraph::visit(Identifier const& _identifier)
{
	auto callee = dynamic_cast<FunctionDefinition const*>(_identifier.annotation().referencedDeclaration);
	// Check that the identifier is within a function body and is a function, and add it to the graph
	// as an ``m_currentNode`` -> ``callee`` edge.
	if (m_inFunctionDefinition && _identifier.annotation().referencedDeclaration && callee)
	{
		solAssert(m_currentNode, "Child node must have a parent");
		add(m_currentNode, callee);
	}
	return true;
}

void FunctionCallGraph::add(FunctionDefinition const* _caller, FunctionDefinition const* _callee)
{
	// Add caller and callee as and edge, as well as the reverse edge, i.e. callee -> caller.
	// If the caller is already in the reverse edges as a childless node, remove it, since it now
	// has a child.
	annotation().functionCallGraph.edges[_caller].insert(_callee);
	annotation().functionCallGraph.reverseEdges[_callee].insert(_caller);
	if (annotation().functionCallGraph.reverseEdges[nullptr].count(_caller) > 0)
		annotation().functionCallGraph.reverseEdges[nullptr].erase(_caller);
}

FunctionCallGraph::GlobalAnnotation& FunctionCallGraph::annotation()
{
	return m_analysis.annotation<FunctionCallGraph>();
}
